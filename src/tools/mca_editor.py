"""Small Anvil block-state adapter over nbtlib and NumPy, for offline map patches.

Unchanged chunks keep their original compressed payload and timestamp. Callers
must stop the target server before saving. World entities/POI are not copied.
"""

from __future__ import annotations

import copy
import gzip
import io
import math
import os
import re
import shutil
import struct
import time
import zlib
from pathlib import Path

import nbtlib as nbt
import numpy as np


AIR = {"Name": "minecraft:air"}
WOOL_COLORS = ("white", "orange", "magenta", "light_blue", "yellow", "lime", "pink", "gray",
               "light_gray", "cyan", "purple", "blue", "brown", "green", "red", "black")


def new_chunk(cx: int, cz: int) -> nbt.File:
    return nbt.File({
        "DataVersion": nbt.Int(3465), "xPos": nbt.Int(cx), "yPos": nbt.Int(-4), "zPos": nbt.Int(cz),
        "Status": nbt.String("minecraft:full"), "LastUpdate": nbt.Long(0), "InhabitedTime": nbt.Long(0),
        "isLightOn": nbt.Byte(0), "sections": nbt.List[nbt.Compound](),
        "block_entities": nbt.List[nbt.Compound](), "block_ticks": nbt.List[nbt.Compound](),
        "fluid_ticks": nbt.List[nbt.Compound](), "Heightmaps": nbt.Compound(),
        "structures": nbt.Compound({"starts": nbt.Compound(), "References": nbt.Compound()}),
        "PostProcessing": nbt.List[nbt.List[nbt.Short]]([nbt.List[nbt.Short]() for _ in range(24)]),
    })


def legacy_terrain(chunk: nbt.File, cx: int, cz: int) -> nbt.File:
    """Decode the six numeric terrain IDs present in this map's old void fringe.

    This is deliberately a terrain adapter, not a general replacement for the
    game's DataFixer. Unknown IDs or old entities require an official Minecraft
    world upgrade first. Unedited legacy chunks are never rewritten by save().
    """
    level = chunk["Level"]
    if level.get("TileEntities") or level.get("Entities") or level.get("TileTicks"):
        raise ValueError(f"Legacy chunk {cx},{cz} has entities/tickers; upgrade it with Minecraft before editing")
    modern = new_chunk(cx, cz)
    modern["LastUpdate"] = nbt.Long(int(level.get("LastUpdate", 0)))
    modern["InhabitedTime"] = nbt.Long(int(level.get("InhabitedTime", 0)))
    sections = []
    for section in level.get("Sections", []):
        if "Blocks" not in section:
            if section.get("Palette"):
                raise ValueError(f"Legacy paletted section at {cx},{cz} requires an official Minecraft upgrade")
            continue
        ids = np.asarray(section["Blocks"], dtype=np.int8).view(np.uint8).astype(np.uint16)
        if ids.size != 4096:
            raise ValueError("Legacy block array must contain 4096 entries")
        data = np.asarray(section.get("Data", np.zeros(2048, dtype=np.int8)), dtype=np.int8).view(np.uint8)
        offsets = np.arange(4096)
        metadata = (data[offsets // 2] >> ((offsets % 2) * 4)) & 15
        if "Add" in section:
            high = np.asarray(section["Add"], dtype=np.int8).view(np.uint8)
            ids |= ((high[offsets // 2] >> ((offsets % 2) * 4)) & 15).astype(np.uint16) << 8
        combined = ids.astype(np.uint32) * 16 + metadata
        keys, inverse = np.unique(combined, return_inverse=True)
        palette = []
        for key in keys:
            block_id, value = divmod(int(key), 16)
            if block_id == 0:
                state = AIR.copy()
            elif block_id == 2:
                state = {"Name": "minecraft:grass_block", "Properties": {"snowy": "false"}}
            elif block_id == 3 and value <= 2:
                state = {"Name": "minecraft:" + ("dirt", "coarse_dirt", "podzol")[value]}
                if value == 2:
                    state["Properties"] = {"snowy": "false"}
            elif block_id == 7:
                state = {"Name": "minecraft:bedrock"}
            elif block_id == 35:
                state = {"Name": "minecraft:" + WOOL_COLORS[value] + "_wool"}
            elif block_id == 80:
                state = {"Name": "minecraft:snow_block"}
            else:
                raise ValueError(f"Unsupported legacy terrain block {block_id}:{value} at {cx},{cz}; upgrade with Minecraft")
            palette.append(state)
        sections.append(nbt.Compound({
            "Y": nbt.Byte(int(section["Y"])),
            "block_states": pack_states(palette, inverse.reshape(16, 16, 16)),
            "biomes": nbt.Compound({"palette": nbt.List[nbt.String]([nbt.String("minecraft:plains")])}),
        }))
    modern["sections"] = nbt.List[nbt.Compound](sections)
    return modern


def parse_state(state: dict | str) -> dict:
    if isinstance(state, dict):
        return state
    match = re.fullmatch(r"([a-z0-9_:]+)(?:\[([^\]]+)\])?", state)
    if match is None:
        raise ValueError(f"Unsupported block state: {state}")
    name, properties = match.groups()
    result = {"Name": name if ":" in name else "minecraft:" + name}
    if properties:
        result["Properties"] = dict(pair.split("=", 1) for pair in properties.split(","))
    return result


def unpack_states(states) -> tuple[list[dict], np.ndarray]:
    palette = [entry.unpack() for entry in states.get("palette", [])] or [AIR.copy()]
    if len(palette) == 1:
        return palette, np.zeros((16, 16, 16), dtype=np.uint16)
    bits = max(4, (len(palette) - 1).bit_length())
    per_word = 64 // bits
    words = np.asarray(states["data"], dtype=np.int64).view(np.uint64)
    offsets = np.arange(4096, dtype=np.uint64)
    values = (words[offsets // per_word] >> ((offsets % per_word) * bits)) & ((1 << bits) - 1)
    if int(values.max()) >= len(palette):
        raise ValueError("Invalid block palette index")
    return palette, values.astype(np.uint16).reshape(16, 16, 16)


def state_key(state: dict) -> tuple:
    return state["Name"], tuple(sorted(state.get("Properties", {}).items()))


def pack_states(palette: list[dict], indices: np.ndarray) -> nbt.Compound:
    indices = np.asarray(indices, dtype=np.uint16).reshape(4096)
    if not palette or int(indices.max()) >= len(palette):
        raise ValueError("Invalid section palette")
    # Compact unused palette entries before writing, including all-air sections.
    used, remap = np.unique(indices, return_inverse=True)
    palette = [palette[int(i)] for i in used]
    states = nbt.Compound({"palette": nbt.List[nbt.Compound]([
        nbt.Compound({"Name": nbt.String(entry["Name"]), **(
            {"Properties": nbt.Compound({k: nbt.String(v) for k, v in entry["Properties"].items()})}
            if entry.get("Properties") else {})}) for entry in palette
    ])})
    if len(palette) > 1:
        bits = max(4, (len(palette) - 1).bit_length())
        per_word = 64 // bits
        packed = np.zeros(math.ceil(4096 / per_word), dtype=np.uint64)
        data = remap.astype(np.uint64)
        # Each lane contains unique destination indices, so bitwise accumulation
        # does not depend on NumPy's repeated-index fancy-assignment semantics.
        for lane in range(per_word):
            values = data[lane::per_word]
            packed[:len(values)] |= values << (lane * bits)
        states["data"] = nbt.LongArray(packed.view(np.int64))
    return states


class WorldEditor:
    def __init__(self, world: Path):
        self.world = Path(world).resolve()
        self.regions: dict[tuple[int, int], tuple[list[bytes | None], list[int]]] = {}
        self.chunks: dict[tuple[int, int], nbt.File | None] = {}
        self.sections: dict[tuple[int, int, int], tuple[list[dict], np.ndarray]] = {}
        self.dirty: set[tuple[int, int]] = set()

    def _region(self, rx: int, rz: int):
        key = rx, rz
        if key in self.regions:
            return self.regions[key]
        path = self.world / "region" / f"r.{rx}.{rz}.mca"
        payloads: list[bytes | None] = [None] * 1024
        timestamps = [0] * 1024
        if path.exists():
            data = path.read_bytes()
            if len(data) < 8192:
                raise ValueError(f"Truncated region: {path}")
            timestamps = list(struct.unpack_from(">1024I", data, 4096))
            for slot in range(1024):
                loc = struct.unpack_from(">I", data, slot * 4)[0]
                if not loc:
                    continue
                offset = (loc >> 8) * 4096
                if offset + 5 > len(data):
                    raise ValueError(f"Invalid region location: {path}, slot {slot}")
                length = struct.unpack_from(">I", data, offset)[0]
                if length <= 1 or offset + 4 + length > len(data):
                    raise ValueError(f"Invalid chunk length: {path}, slot {slot}")
                payloads[slot] = data[offset:offset + 4 + length]
        self.regions[key] = payloads, timestamps
        return payloads, timestamps

    def get_chunk(self, cx: int, cz: int, create=False) -> nbt.File | None:
        key = cx, cz
        if key not in self.chunks:
            payloads, _ = self._region(cx // 32, cz // 32)
            payload = payloads[(cx % 32) + (cz % 32) * 32]
            if payload is None:
                self.chunks[key] = None
            else:
                compression = payload[4]
                raw = payload[5:]
                if compression == 1:
                    raw = gzip.decompress(raw)
                elif compression == 2:
                    raw = zlib.decompress(raw)
                elif compression != 3:
                    raise ValueError(f"Unsupported Anvil compression {compression}")
                chunk = nbt.File.parse(io.BytesIO(raw))
                self.chunks[key] = legacy_terrain(chunk, cx, cz) if "Level" in chunk else chunk
        if self.chunks[key] is None and create:
            self.chunks[key] = new_chunk(cx, cz)
        return self.chunks[key]

    def get_section(self, cx: int, cz: int, sy: int) -> tuple[list[dict], np.ndarray]:
        key = cx, cz, sy
        if key not in self.sections:
            chunk = self.get_chunk(cx, cz)
            section = next((s for s in chunk.get("sections", []) if int(s["Y"]) == sy), None) if chunk is not None else None
            states = section.get("block_states", {}) if section is not None else {}
            self.sections[key] = unpack_states(states)
        return self.sections[key]

    def set_section(self, cx: int, cz: int, sy: int, palette: list[dict], indices: np.ndarray):
        if not -4 <= sy <= 19:
            raise ValueError(f"Overworld section outside 1.20.1 bounds: {sy}")
        self.get_chunk(cx, cz, create=True)
        self.sections[cx, cz, sy] = copy.deepcopy(palette), np.array(indices, dtype=np.uint16, copy=True).reshape(16, 16, 16)
        self.dirty.add((cx, cz))

    def get_block(self, x: int, y: int, z: int) -> dict:
        palette, indices = self.get_section(x // 16, z // 16, y // 16)
        return copy.deepcopy(palette[int(indices[y % 16, z % 16, x % 16])])

    def set_block(self, x: int, y: int, z: int, state: dict | str):
        state = parse_state(state)
        cx, cz, sy = x // 16, z // 16, y // 16
        if not -4 <= sy <= 19:
            raise ValueError(f"Overworld Y outside 1.20.1 bounds: {y}")
        palette, indices = self.get_section(cx, cz, sy)
        target_key = state_key(state)
        index = next((i for i, p in enumerate(palette) if state_key(p) == target_key), None)
        if index is None:
            index = len(palette)
            palette.append(copy.deepcopy(state))
        indices[y % 16, z % 16, x % 16] = index
        self.get_chunk(cx, cz, create=True)
        self.dirty.add((cx, cz))

    def fill(self, bounds: dict | tuple, state: dict | str):
        """Fill an inclusive cuboid; tuple order is x0,y0,z0,x1,y1,z1."""
        if isinstance(bounds, dict):
            x0, y0, z0 = (bounds[f"min_{axis}"] for axis in ("x", "y", "z"))
            x1, y1, z1 = (bounds[f"max_{axis}"] for axis in ("x", "y", "z"))
        else:
            x0, y0, z0, x1, y1, z1 = bounds
        if x1 < x0 or y1 < y0 or z1 < z0 or y0 < -64 or y1 > 319:
            raise ValueError(f"Invalid fill bounds: {bounds}")
        state = parse_state(state)
        wanted = state_key(state)
        for cz in range(z0 // 16, z1 // 16 + 1):
            zs = slice(max(0, z0 - cz * 16), min(16, z1 - cz * 16 + 1))
            for cx in range(x0 // 16, x1 // 16 + 1):
                xs = slice(max(0, x0 - cx * 16), min(16, x1 - cx * 16 + 1))
                self.get_chunk(cx, cz, create=True)
                for sy in range(y0 // 16, y1 // 16 + 1):
                    ys = slice(max(0, y0 - sy * 16), min(16, y1 - sy * 16 + 1))
                    palette, indices = self.get_section(cx, cz, sy)
                    index = next((i for i, entry in enumerate(palette) if state_key(entry) == wanted), None)
                    if index is None:
                        index = len(palette)
                        palette.append(copy.deepcopy(state))
                    indices[ys, zs, xs] = index
                self.dirty.add((cx, cz))

    def clear_block_entities(self, bounds: dict):
        """Remove machinery only inside a patch, retaining shared-chunk neighbors."""
        for (cx, cz), chunk in self.chunks.items():
            if chunk is None or (cx, cz) not in self.dirty:
                continue
            chunk["block_entities"] = nbt.List[nbt.Compound]([
                entity for entity in chunk.get("block_entities", [])
                if not all(bounds[f"min_{axis}"] <= int(entity[axis]) <= bounds[f"max_{axis}"]
                           for axis in ("x", "y", "z"))
            ])

    def save(self, backup_dir: Path | None = None) -> list[Path]:
        if backup_dir is not None:
            backup_dir = Path(backup_dir).resolve()
            if backup_dir == self.world or self.world in backup_dir.parents:
                raise ValueError("Backup must be outside the target world")
            backup_dir.mkdir(parents=True, exist_ok=True)
        region_changes: dict[tuple[int, int], set[tuple[int, int]]] = {}
        for cx, cz in self.dirty:
            region_changes.setdefault((cx // 32, cz // 32), set()).add((cx, cz))
            chunk = self.get_chunk(cx, cz)
            sections = {int(s["Y"]): s for s in chunk.get("sections", [])}
            kept_entities = []
            for entity in chunk.get("block_entities", []):
                x, y, z = (int(entity[axis]) for axis in ("x", "y", "z"))
                section = sections.get(y // 16)
                before_palette, before_indices = unpack_states(section.get("block_states", {}) if section is not None else {})
                before = before_palette[int(before_indices[y % 16, z % 16, x % 16])]
                after = self.get_block(x, y, z)
                if state_key(before) == state_key(after):
                    kept_entities.append(entity)
            for (sx, sz, sy), (palette, indices) in self.sections.items():
                if (sx, sz) != (cx, cz):
                    continue
                section = sections.setdefault(sy, nbt.Compound({"Y": nbt.Byte(sy)}))
                section["block_states"] = pack_states(palette, indices)
                if "biomes" not in section:
                    section["biomes"] = nbt.Compound({"palette": nbt.List[nbt.String]([nbt.String("minecraft:snowy_taiga")])})
            chunk["sections"] = nbt.List[nbt.Compound]([sections[y] for y in sorted(sections)])
            chunk["isLightOn"] = nbt.Byte(0)
            chunk["Heightmaps"] = nbt.Compound()
            for section in chunk["sections"]:
                section.pop("BlockLight", None)
                section.pop("SkyLight", None)
            chunk["block_entities"] = nbt.List[nbt.Compound](kept_entities)
            raw = io.BytesIO()
            chunk.write(raw)
            encoded = zlib.compress(raw.getvalue())
            payloads, timestamps = self._region(cx // 32, cz // 32)
            slot = (cx % 32) + (cz % 32) * 32
            payloads[slot] = struct.pack(">I", len(encoded) + 1) + b"\x02" + encoded
            timestamps[slot] = int(time.time())
        paths = []
        for rx, rz in sorted(region_changes):
            path = self.world / "region" / f"r.{rx}.{rz}.mca"
            path.parent.mkdir(parents=True, exist_ok=True)
            if backup_dir is not None and path.exists():
                backup = backup_dir / path.name
                if backup.exists():
                    raise FileExistsError(f"Refusing to overwrite original backup: {backup}")
                shutil.copy2(path, backup)
            payloads, timestamps = self._region(rx, rz)
            header = bytearray(8192)
            struct.pack_into(">1024I", header, 4096, *timestamps)
            parts = []
            sector = 2
            for slot, payload in enumerate(payloads):
                if payload is None:
                    continue
                count = math.ceil(len(payload) / 4096)
                if count > 255:
                    raise ValueError("External oversized Anvil chunks are not supported")
                struct.pack_into(">I", header, slot * 4, (sector << 8) | count)
                parts.append(payload + b"\0" * (count * 4096 - len(payload)))
                sector += count
            temporary = path.with_suffix(".mca.shadow.tmp")
            try:
                with temporary.open("wb") as handle:
                    handle.write(header)
                    for part in parts:
                        handle.write(part)
                    handle.flush()
                    os.fsync(handle.fileno())
                os.replace(temporary, path)
            finally:
                temporary.unlink(missing_ok=True)
            paths.append(path)
        self.dirty.clear()
        return paths
