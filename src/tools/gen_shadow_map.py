"""Reflect a real Minecraft terrain region into the shadow mountain.

The source world is read-only. Terrain is copied into the explicitly selected
target world by section palettes, so caves and multi-level terrain survive.
"""

from __future__ import annotations

import argparse
import json
import math
import os
import sys
from pathlib import Path
from typing import Any

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from mca_editor import WorldEditor, state_key


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_SOURCE = ROOT / "梦回盘灵服务端" / "world"
DEFAULT_MANIFEST = Path(__file__).with_name("shadow_layout.json")

# Remove the original arena's invisible boundaries and dormant block-entity
# machinery. Visual stone, roads, fossils, caves, and the rest of the terrain
# are mirrored from their palettes.
NEUTRALIZED = {
    "minecraft:barrier": "minecraft:air",
    "minecraft:command_block": "minecraft:air",
    "minecraft:chain_command_block": "minecraft:air",
    "minecraft:repeating_command_block": "minecraft:air",
    "minecraft:structure_block": "minecraft:air",
    "minecraft:structure_void": "minecraft:air",
    "minecraft:redstone_wire": "minecraft:air",
    "minecraft:redstone_torch": "minecraft:air",
    "minecraft:redstone_wall_torch": "minecraft:air",
    "minecraft:repeater": "minecraft:air",
    "minecraft:comparator": "minecraft:air",
    "minecraft:observer": "minecraft:air",
}

# Cool stone palette, applied to strongly warm-colored ground/building blocks.
# Ordinary stone, andesite, tuff, deepslate, snow, and water keep their shape.
COLD_GRAY = {
    "minecraft:grass_block": "minecraft:stone",
    "minecraft:dirt": "minecraft:stone",
    "minecraft:coarse_dirt": "minecraft:stone",
    "minecraft:podzol": "minecraft:stone",
    "minecraft:mycelium": "minecraft:stone",
    "minecraft:granite": "minecraft:polished_andesite",
    "minecraft:granite_slab": "minecraft:polished_andesite_slab",
    "minecraft:granite_stairs": "minecraft:polished_andesite_stairs",
    "minecraft:granite_wall": "minecraft:polished_blackstone_brick_wall",
    "minecraft:red_sand": "minecraft:gravel",
    "minecraft:red_sandstone": "minecraft:stone",
    "minecraft:cut_red_sandstone": "minecraft:stone",
    "minecraft:red_sandstone_slab": "minecraft:stone_slab",
    "minecraft:red_sandstone_stairs": "minecraft:stone_stairs",
    "minecraft:netherrack": "minecraft:deepslate",
    "minecraft:nether_bricks": "minecraft:deepslate_bricks",
    "minecraft:red_nether_bricks": "minecraft:deepslate_bricks",
    "minecraft:nether_brick_slab": "minecraft:deepslate_brick_slab",
    "minecraft:red_nether_brick_slab": "minecraft:deepslate_brick_slab",
    "minecraft:nether_brick_stairs": "minecraft:deepslate_brick_stairs",
    "minecraft:red_nether_brick_stairs": "minecraft:deepslate_brick_stairs",
    "minecraft:terracotta": "minecraft:gray_terracotta",
    "minecraft:orange_terracotta": "minecraft:gray_terracotta",
    "minecraft:yellow_terracotta": "minecraft:light_gray_terracotta",
    "minecraft:brown_terracotta": "minecraft:gray_terracotta",
    "minecraft:sandstone": "minecraft:cobblestone",
    "minecraft:cut_sandstone": "minecraft:cobblestone",
    "minecraft:sandstone_slab": "minecraft:cobblestone_slab",
    "minecraft:sandstone_stairs": "minecraft:cobblestone_stairs",
    "minecraft:quartz_block": "minecraft:calcite",
    "minecraft:quartz_pillar": "minecraft:calcite",
    "minecraft:quartz_bricks": "minecraft:calcite",
    "minecraft:quartz_slab": "minecraft:smooth_stone_slab",
    "minecraft:quartz_stairs": "minecraft:stone_stairs",
}

GRAY_WOOL = {
    "minecraft:white_wool": "minecraft:stone",
    "minecraft:light_gray_wool": "minecraft:andesite",
    "minecraft:gray_wool": "minecraft:tuff",
    "minecraft:black_wool": "minecraft:deepslate",
}


def load_manifest(path: Path = DEFAULT_MANIFEST) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def reflect_x(x: int, axis: float) -> int:
    """Reflect an integer block coordinate about an integer/half-block axis."""
    reflected = 2 * axis - x
    if not float(reflected).is_integer():
        raise ValueError("Mirror axis must be an integer or half-integer")
    return int(reflected)


def mirror_state(raw: dict[str, Any], gray: bool = True) -> dict[str, Any]:
    """Mirror directional block states and optionally cool warm materials."""
    name = str(raw["Name"])
    properties = {str(k): str(v) for k, v in raw.get("Properties", {}).items()}
    if gray:
        name = GRAY_WOOL.get(name, COLD_GRAY.get(name, name))
        if name.endswith("_terracotta"):
            name = "minecraft:gray_terracotta"
        if name.endswith("_wool") or name.endswith("_carpet") or name.endswith("_concrete") or name.endswith("_concrete_powder"):
            name = "minecraft:deepslate" if "black" in name or "blue" in name else "minecraft:andesite"
        if name.endswith("_glazed_terracotta"):
            name = "minecraft:polished_andesite"
        if name == "minecraft:spawner":
            name = "minecraft:mossy_cobblestone"
        if name in {"minecraft:lava", "minecraft:flowing_lava"}:
            name = "minecraft:obsidian"
        if name == "minecraft:redstone_ore":
            name = "minecraft:coal_ore"
    name = NEUTRALIZED.get(name, name)
    if name in {"minecraft:air", "minecraft:cave_air", "minecraft:void_air"}:
        return {"Name": "minecraft:air"}
    if name != str(raw["Name"]) and name not in {
        "minecraft:stone_stairs", "minecraft:smooth_stone_slab", "minecraft:stone_slab",
        "minecraft:cobblestone_slab", "minecraft:cobblestone_stairs", "minecraft:deepslate_brick_slab",
        "minecraft:deepslate_brick_stairs", "minecraft:polished_andesite_slab", "minecraft:polished_andesite_stairs",
        "minecraft:polished_blackstone_brick_wall",
    }:
        properties = {}
    if "facing" in properties:
        properties["facing"] = {"east": "west", "west": "east"}.get(properties["facing"], properties["facing"])
    if "east" in properties and "west" in properties:
        properties["east"], properties["west"] = properties["west"], properties["east"]
    if name.endswith("chest") and properties.get("type") in {"left", "right"}:
        properties["type"] = {"left": "right", "right": "left"}[properties["type"]]
    if properties.get("hinge") in {"left", "right"}:
        properties["hinge"] = {"left": "right", "right": "left"}[properties["hinge"]]
    if properties.get("shape") in {"inner_left", "outer_left"}:
        properties["shape"] = properties["shape"].replace("left", "right")
    elif properties.get("shape") in {"inner_right", "outer_right"}:
        properties["shape"] = properties["shape"].replace("right", "left")
    if "rotation" in properties:
        properties["rotation"] = str((16 - int(properties["rotation"])) % 16)
    if "shape" in properties:
        properties["shape"] = {
            "ascending_east": "ascending_west", "ascending_west": "ascending_east",
            "north_east": "north_west", "north_west": "north_east",
            "south_east": "south_west", "south_west": "south_east",
        }.get(properties["shape"], properties["shape"])
    state = {"Name": name}
    if properties:
        state["Properties"] = properties
    return state


def _palette_states(palette: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [{"Name": str(state["Name"]), **({"Properties": {str(k): str(v) for k, v in state["Properties"].items()}} if "Properties" in state else {})} for state in palette]


def reflect_region(
    source: WorldEditor,
    target: WorldEditor,
    bounds: dict[str, int],
    axis_x: float,
    cold_gray: bool = True,
) -> dict[str, Any]:
    """Copy the inclusive source box to its exact X reflection in sections."""
    sx0, sx1 = bounds["min_x"], bounds["max_x"]
    sy0, sy1 = bounds["min_y"], bounds["max_y"]
    sz0, sz1 = bounds["min_z"], bounds["max_z"]
    tx0, tx1 = sorted((reflect_x(sx0, axis_x), reflect_x(sx1, axis_x)))
    written = 0
    palette_counts: dict[str, int] = {}
    barrier_count = 0

    for cz in range(sz0 // 16, sz1 // 16 + 1):
        z0, z1 = max(sz0, cz * 16), min(sz1, cz * 16 + 15)
        for cx in range(sx0 // 16, sx1 // 16 + 1):
            x0, x1 = max(sx0, cx * 16), min(sx1, cx * 16 + 15)
            for sy in range(sy0 // 16, sy1 // 16 + 1):
                src_palette, src = source.get_section(cx, cz, sy)
                source_states = _palette_states(src_palette)
                mapped_states = [mirror_state(state, cold_gray) for state in source_states]
                source_to_target: dict[int, int] = {}
                source_xs = np.arange(x0, x1 + 1, dtype=np.int32)
                target_xs = (2 * axis_x - source_xs).astype(np.int32)
                for target_cx in np.unique(target_xs // 16):
                    mask = target_xs // 16 == target_cx
                    src_local_x = source_xs[mask] - cx * 16
                    dst_local_x = target_xs[mask] - int(target_cx) * 16
                    for target_cz in (cz,):
                        dst_palette, dst = target.get_section(int(target_cx), target_cz, sy)
                        dst_palette = _palette_states(dst_palette)
                        dst_lookup = {state_key(state): idx for idx, state in enumerate(dst_palette)}
                        for source_index, state in enumerate(mapped_states):
                            key = state_key(state)
                            if key not in dst_lookup:
                                dst_lookup[key] = len(dst_palette)
                                dst_palette.append(state)
                            source_to_target[source_index] = dst_lookup[key]
                        translation = np.asarray(
                            [source_to_target[i] for i in range(len(source_states))], dtype=np.uint32
                        )
                        dst_z = np.arange(z0, z1 + 1, dtype=np.int32) - cz * 16
                        src_slice = src[:, dst_z[:, None], src_local_x[None, :]]
                        dst[:, dst_z[:, None], dst_local_x[None, :]] = translation[src_slice]
                        target.set_section(int(target_cx), target_cz, sy, dst_palette, dst)
                        written += int(src.shape[0] * len(dst_z) * len(src_local_x))
                        selected = src_slice.reshape(-1)
                        for source_index, occurrences in enumerate(
                            np.bincount(selected, minlength=len(source_states))
                        ):
                            if occurrences:
                                mapped = mapped_states[source_index]["Name"]
                                palette_counts[mapped] = palette_counts.get(mapped, 0) + int(occurrences)
                                if source_states[source_index]["Name"] == "minecraft:barrier":
                                    barrier_count += int(occurrences)
    return {
        "source_bounds": bounds,
        "target_bounds": {"min_x": tx0, "max_x": tx1, "min_y": sy0, "max_y": sy1, "min_z": sz0, "max_z": sz1},
        "axis_x": axis_x,
        "voxel_columns_written": written,
        "source_barrier_count_removed": barrier_count,
        "palette_counts": palette_counts,
    }


def _ensure_unlocked(world: Path) -> None:
    lock = world / "session.lock"
    if not lock.exists():
        return
    descriptor = os.open(lock, os.O_RDWR)
    try:
        if os.name == "nt":
            import msvcrt

            os.lseek(descriptor, 0, os.SEEK_SET)
            msvcrt.locking(descriptor, msvcrt.LK_NBLCK, 8)
            msvcrt.locking(descriptor, msvcrt.LK_UNLCK, 8)
        else:
            import fcntl

            fcntl.flock(descriptor, fcntl.LOCK_EX | fcntl.LOCK_NB)
            fcntl.flock(descriptor, fcntl.LOCK_UN)
    except OSError as exc:
        raise RuntimeError(f"World is locked by a running server: {world}") from exc
    finally:
        os.close(descriptor)


def _snapshot_technical_blocks(editor: WorldEditor, bounds: dict[str, int]) -> list[tuple[int, int, int, dict[str, Any]]]:
    """Preserve sparse original bedrock markers embedded in the mirrored zone."""
    blocks = []
    for x in range(bounds["min_x"], bounds["max_x"] + 1):
        for z in range(bounds["min_z"], bounds["max_z"] + 1):
            state = editor.get_block(x, bounds["y"], z)
            if state["Name"] == "minecraft:bedrock":
                blocks.append((x, bounds["y"], z, state))
    return blocks


def _fill(editor: WorldEditor, bounds: tuple[int, int, int, int, int, int], block: str) -> None:
    editor.fill(bounds, block)


def _support_to_ground(editor: WorldEditor, x: int, z: int, top_y: int) -> int:
    """Anchor an elevated terrace with a deepslate pier down to its ledge."""
    ground_y = None
    for y in range(top_y - 1, -65, -1):
        name = editor.get_block(x, y, z)["Name"]
        if name not in {"minecraft:air", "minecraft:cave_air", "minecraft:void_air", "minecraft:water"}:
            ground_y = y
            break
    if ground_y is not None and ground_y < top_y - 1:
        _fill(editor, (x - 1, ground_y + 1, z - 1, x + 1, top_y - 1, z + 1), "deepslate_bricks")
        return ground_y
    return top_y - 1


def _build_house(
    editor: WorldEditor,
    bounds: tuple[int, int, int, int],
    floor_y: int,
    wall: str,
    roof: str,
    door_x: int,
    door_z: int,
) -> None:
    """Build a small stone house with an open doorway and stepped roof."""
    x0, x1, z0, z1 = bounds
    _fill(editor, (x0, floor_y + 1, z0, x1, floor_y + 8, z1), "air")
    _fill(editor, (x0, floor_y, z0, x1, floor_y, z1), "polished_andesite")
    for y in range(floor_y + 1, floor_y + 5):
        for x in range(x0, x1 + 1):
            for z in (z0, z1):
                if (x, z) in {(door_x, door_z), (door_x, door_z - 1)}:
                    continue
                editor.set_block(x, y, z, wall)
        for z in range(z0 + 1, z1):
            for x in (x0, x1):
                editor.set_block(x, y, z, wall)
    # Upper windows sit above eye level and leave the corners solid.
    for x in (x0 + 1, x1 - 1):
        editor.set_block(x, floor_y + 3, z0, "gray_stained_glass")
        editor.set_block(x, floor_y + 3, z1, "gray_stained_glass")
    for z in (z0 + 1, z1 - 1):
        editor.set_block(x0, floor_y + 3, z, "gray_stained_glass")
        editor.set_block(x1, floor_y + 3, z, "gray_stained_glass")
    for layer in range(3):
        y = floor_y + 5 + layer
        _fill(editor, (x0 + layer, y, z0 + layer, x1 - layer, y, z1 - layer), roof)
    _fill(editor, (door_x, floor_y + 1, door_z, door_x, floor_y + 2, door_z), "air")
    editor.set_block(door_x, floor_y, door_z, "polished_andesite")


def build_landmarks(editor: WorldEditor, manifest: dict[str, Any]) -> dict[str, int]:
    """Add an elevated stone town, legible streets, and small wilderness ruins."""
    # The mirrored source has a compact cliff-top NPC platform. Extend it into
    # an anchored, terraced settlement instead of flattening the mountain.
    _fill(editor, (-715, 205, -1463, -694, 205, -1447), "polished_andesite")
    _fill(editor, (-716, 201, -1474, -700, 201, -1464), "andesite")
    _fill(editor, (-723, 199, -1461, -715, 199, -1448), "andesite")
    _fill(editor, (-692, 195, -1473, -686, 195, -1466), "andesite")
    # Three-block lanes connect the raised court to the western and eastern
    # ledges. Their stair flights preserve walkable elevation changes.
    _fill(editor, (-708, 201, -1474, -706, 201, -1465), "polished_andesite")
    _fill(editor, (-723, 199, -1453, -715, 199, -1451), "andesite")
    _fill(editor, (-692, 195, -1470, -686, 195, -1468), "andesite")
    for x, y, z, facing in [
        (-707, 202, -1464, "south"), (-707, 203, -1463, "south"),
        (-707, 204, -1462, "south"), (-715, 200, -1452, "east"),
        (-714, 201, -1452, "east"), (-713, 202, -1452, "east"),
        (-712, 203, -1452, "east"), (-711, 204, -1452, "east"),
        (-693, 196, -1469, "west"), (-694, 197, -1469, "west"),
        (-695, 198, -1469, "west"),
        (-712, 206, -1446, "south"), (-712, 207, -1445, "south"),
    ]:
        editor.set_block(x, y, z, f"stone_stairs[facing={facing},half=bottom,shape=straight,waterlogged=false]")
    for x, z, y in [(-721, -1472, 201), (-689, -1470, 195), (-721, -1437, 205), (-689, -1437, 198)]:
        _support_to_ground(editor, x, z, y)

    # Functional street frontages. Each house has a walk-in opening, windows,
    # an articulated roof and a clean floor for the marker-owned NPC station.
    _build_house(editor, (-712, -705, -1460, -1453), 205, "deepslate_bricks", "deepslate_tiles", -708, -1460)
    _build_house(editor, (-704, -697, -1460, -1453), 205, "stone_bricks", "polished_deepslate", -701, -1460)
    _build_house(editor, (-723, -716, -1471, -1464), 201, "stone_bricks", "andesite", -720, -1471)
    _build_house(editor, (-723, -716, -1458, -1451), 205, "stone_bricks", "polished_andesite", -720, -1458)
    _build_house(editor, (-692, -686, -1473, -1467), 195, "deepslate_bricks", "deepslate_tiles", -689, -1473)

    # A shrine tower, watchtower and lantern posts make the silhouette readable
    # from the reflected approach trail.
    _fill(editor, (-723, 206, -1447, -718, 206, -1439), "tuff")
    _fill(editor, (-723, 207, -1447, -718, 217, -1447), "polished_deepslate")
    _fill(editor, (-723, 207, -1439, -718, 217, -1439), "polished_deepslate")
    _fill(editor, (-723, 207, -1446, -723, 217, -1440), "polished_deepslate")
    _fill(editor, (-718, 207, -1446, -718, 217, -1440), "polished_deepslate")
    _fill(editor, (-722, 218, -1446, -719, 218, -1440), "deepslate_bricks")
    _fill(editor, (-721, 219, -1445, -720, 219, -1441), "tuff")
    editor.set_block(-720, 220, -1443, "soul_lantern")

    # The south gate is a separate, solid landing at the exact reflected fight
    # point; the arena itself is constructed below ground by its own builder.
    _fill(editor, (-715, 207, -1445, -709, 207, -1439), "polished_deepslate")
    _fill(editor, (-713, 207, -1443, -711, 207, -1441), "polished_andesite")
    _fill(editor, (-715, 208, -1445, -715, 212, -1445), "stone_bricks")
    _fill(editor, (-709, 208, -1445, -709, 212, -1445), "stone_bricks")
    _fill(editor, (-715, 208, -1439, -715, 212, -1439), "stone_bricks")
    _fill(editor, (-709, 208, -1439, -709, 212, -1439), "stone_bricks")
    _fill(editor, (-714, 213, -1445, -710, 213, -1445), "deepslate_bricks")
    _fill(editor, (-714, 213, -1439, -710, 213, -1439), "deepslate_bricks")
    editor.set_block(-715, 214, -1445, "soul_lantern")
    editor.set_block(-709, 214, -1439, "soul_lantern")

    # Small broken shrines on the five natural route landings make wilderness
    # zones visually discoverable without flattening their terrain.
    spawns = manifest["landmarks"]["wilderness_spawn_points"]
    for spawn in spawns:
        x, y, z = (math.floor(float(v)) for v in spawn["feet"])
        _fill(editor, (x - 2, y - 1, z - 2, x + 2, y - 1, z + 2), "tuff")
        for px, pz, height in ((x - 2, z - 2, 3), (x + 2, z - 2, 2), (x - 2, z + 2, 2)):
            _fill(editor, (px, y, pz, px, y + height, pz), "cracked_stone_bricks")
        editor.set_block(x, y - 1, z, "polished_andesite")
        editor.set_block(x, y, z, "air")
        editor.set_block(x, y + 1, z, "air")

    route_blocks = build_walk_routes(editor, manifest["landmarks"]["walk_routes"])

    return {
        "town_blocks_and_ruins_added": 1,
        "wild_spawn_ruins": len(spawns),
        "walk_route_blocks_added": route_blocks,
    }


def _path_points(route: dict[str, Any]) -> list[tuple[int, int, int]]:
    points = [tuple(int(v) for v in route["points"][0])]
    for target in route["points"][1:]:
        x, z, y = (int(v) for v in target)
        cx, cz, cy = points[-1]
        total = abs(x - cx) + abs(z - cz)
        if abs(y - cy) > total:
            raise ValueError(f"Route {route['id']} changes height faster than 1 block per step")
        steps: list[tuple[int, int]] = []
        dx = 1 if x > cx else -1
        for nx in range(cx + dx, x + dx, dx) if x != cx else ():
            steps.append((nx, cz))
        dz = 1 if z > cz else -1
        for nz in range(cz + dz, z + dz, dz) if z != cz else ():
            steps.append((x, nz))
        for index, (nx, nz) in enumerate(steps, 1):
            ny = round(cy + (y - cy) * index / total)
            points.append((nx, nz, ny))
        if total == 0:
            points[-1] = (x, z, y)
    return points


def build_walk_routes(editor: WorldEditor, routes: list[dict[str, Any]]) -> int:
    """Build returnable, three-block walking trails with stairs and supports."""
    block_count = 0
    for route in routes:
        points = _path_points(route)
        previous = points[0]
        for index, (x, z, y) in enumerate(points):
            if index:
                px, pz, py = previous
                direction = (x - px, z - pz)
            else:
                direction = (0, 0)
            for dx in (-1, 0, 1):
                for dz in (-1, 0, 1):
                    editor.set_block(x + dx, y - 1, z + dz, "polished_andesite")
                    editor.set_block(x + dx, y, z + dz, "air")
                    editor.set_block(x + dx, y + 1, z + dz, "air")
                    editor.set_block(x + dx, y + 2, z + dz, "air")
                    block_count += 4
            if index and y != previous[2]:
                facing_x, facing_z = direction
                if y < previous[2]:
                    facing_x, facing_z = -facing_x, -facing_z
                facing = "east" if facing_x > 0 else "west" if facing_x < 0 else "south" if facing_z > 0 else "north"
                for dx in (-1, 0, 1):
                    for dz in (-1, 0, 1):
                        editor.set_block(
                            x + dx,
                            y - 1,
                            z + dz,
                            f"stone_stairs[facing={facing},half=bottom,shape=straight,waterlogged=false]",
                        )
            # Stone-brick rails keep the elevated legs safe; gaps at the bridge
            # ends and corners preserve clear entry and sight lines.
            if index % 3 == 0 and index not in (0, len(points) - 1):
                px, pz, _ = previous
                side_x, side_z = (1, 0) if direction[1] else (0, 1)
                for side in (-2, 2):
                    editor.set_block(x + side_x * side, y, z + side_z * side, "stone_brick_wall")
            # Short piers follow the cliff at regular intervals. They stop at
            # the first mirrored solid layer and never fill a ravine wholesale.
            if index % 8 == 0 and index not in (0, len(points) - 1):
                _support_to_ground(editor, x, z, y - 1)
            if index % 24 == 12:
                side_x, side_z = (1, 0) if direction[1] else (0, 1)
                post_x, post_z = x + side_x * 2, z + side_z * 2
                _fill(editor, (post_x, y, post_z, post_x, y + 2, post_z), "deepslate_bricks")
                editor.set_block(post_x, y + 3, post_z, "soul_lantern")
            previous = (x, z, y)
    return block_count


def build(args: argparse.Namespace) -> None:
    manifest = load_manifest(args.manifest)
    source_name = args.profile or manifest.get("selected_source")
    profile = manifest.get("sources", {}).get(source_name)
    if profile is None and not args.overlay_only:
        raise SystemExit("Select a valid --profile from shadow_layout.json.")
    if not args.apply:
        raise SystemExit("No world changed. Pass --apply after reviewing the selected source profile.")
    if not args.target_world or not args.backup_dir:
        raise SystemExit("--target-world and --backup-dir are required with --apply.")
    target_path = args.target_world.resolve()
    if not target_path.is_dir():
        raise SystemExit(f"Target world does not exist: {target_path}")
    _ensure_unlocked(target_path)
    backup_path = args.backup_dir.resolve()
    target = WorldEditor(target_path)
    if args.overlay_only:
        construction = manifest["landmarks"]["construction_boxes"]["town_and_market"]
        target.clear_block_entities(construction)
        result = {"overlay_only": True}
    else:
        source_path = args.source_world.resolve()
        source = WorldEditor(source_path)
        technical = _snapshot_technical_blocks(target, manifest["preserve_technical_bedrock"])
        result = reflect_region(source, target, profile["bounds"], float(profile["axis_x"]))
        target.clear_block_entities(result["target_bounds"])
        for x, y, z, state in technical:
            target.set_block(x, y, z, state)
        result["restored_technical_bedrock_blocks"] = len(technical)
    result.update(build_landmarks(target, manifest))
    signature = manifest["signature"]
    target.set_block(*signature["pos"], signature["block"])
    saved = target.save(backup_path)
    result["target_world"] = str(target_path)
    result["backups"] = [str(path) for path in saved]
    result["signature"] = signature
    print(json.dumps(result, ensure_ascii=False, indent=2))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-world", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--target-world", type=Path)
    parser.add_argument("--backup-dir", type=Path)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--profile", help="Source profile in the manifest")
    parser.add_argument("--apply", action="store_true", help="Write mirrored chunks after backup/lock checks")
    parser.add_argument("--overlay-only", action="store_true", help="Update town/route overlays without re-mirroring terrain")
    args = parser.parse_args()
    build(args)


if __name__ == "__main__":
    main()
