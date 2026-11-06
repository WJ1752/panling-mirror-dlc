"""Inspect the installed shadow world against its original terrain and 1.20.1 registry."""

import argparse
import json
import math
import sys
from collections import Counter
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from mca_editor import WorldEditor, state_key


def codes(palette, array, registry):
    mapping = []
    for state in palette:
        key = state_key(state)
        if key not in registry:
            registry[key] = len(registry)
        mapping.append(registry[key])
    return np.asarray(mapping, dtype=np.uint32)[array]


def is_natural(name):
    block = name.removeprefix("minecraft:")
    return block in {
        "stone", "andesite", "diorite", "granite", "tuff", "calcite", "deepslate",
        "cobbled_deepslate", "cobblestone", "mossy_cobblestone", "basalt", "smooth_basalt",
        "blackstone", "bedrock", "obsidian", "crying_obsidian", "snow", "snow_block",
        "ice", "packed_ice", "blue_ice", "water", "lava", "gravel", "sand", "clay",
        "dirt", "coarse_dirt", "grass_block", "podzol", "moss_block", "netherrack",
        "coal_block", "amethyst_block", "budding_amethyst", "glowstone",
    } or block.endswith(("_ore", "_terracotta", "_log", "_leaves")) or block == "terracotta"


def inspect(source, target, layout, block_report):
    profile = layout["sources"][layout["selected_source"]]
    bounds, target_bounds = profile["bounds"], profile["target_bounds"]
    width = bounds["max_x"] - bounds["min_x"] + 1
    depth = bounds["max_z"] - bounds["min_z"] + 1
    assert target_bounds["max_x"] - target_bounds["min_x"] + 1 >= width
    assert target_bounds["max_z"] - target_bounds["min_z"] + 1 >= depth
    assert target_bounds["max_x"] + 1 == bounds["min_x"], "mountains must touch"
    assert target_bounds["min_z"] == bounds["min_z"] and target_bounds["max_z"] == bounds["max_z"]
    source_voxels = 0
    # Compare actual source blocks, including the partial chunk shared by both
    # mountains; whole region hashes cannot distinguish that boundary correctly.
    for cz in range(bounds["min_z"] // 16, bounds["max_z"] // 16 + 1):
        z0 = max(0, bounds["min_z"] - cz * 16)
        z1 = min(16, bounds["max_z"] - cz * 16 + 1)
        for cx in range(bounds["min_x"] // 16, bounds["max_x"] // 16 + 1):
            x0 = max(0, bounds["min_x"] - cx * 16)
            x1 = min(16, bounds["max_x"] - cx * 16 + 1)
            def original_entities(world):
                chunk = world.get_chunk(cx, cz)
                if chunk is None:
                    return []
                return sorted(entity.snbt() for entity in chunk.get("block_entities", [])
                              if all(bounds[f"min_{axis}"] <= int(entity[axis]) <= bounds[f"max_{axis}"]
                                     for axis in ("x", "y", "z")))
            assert original_entities(source) == original_entities(target), f"Original block entity altered at {cx},{cz}"
            for sy in range(bounds["min_y"] // 16, bounds["max_y"] // 16 + 1):
                p0, a0 = source.get_section(cx, cz, sy)
                p1, a1 = target.get_section(cx, cz, sy)
                mapping = {}
                before = codes(p0, a0[:, z0:z1, x0:x1], mapping)
                after = codes(p1, a1[:, z0:z1, x0:x1], mapping)
                assert np.array_equal(before, after), f"Original mountain altered at chunk {cx},{cz}, section {sy}"
                source_voxels += before.size
    counts = Counter()
    invalid = []
    for cz in range(target_bounds["min_z"] // 16, target_bounds["max_z"] // 16 + 1):
        z0 = max(0, target_bounds["min_z"] - cz * 16)
        z1 = min(16, target_bounds["max_z"] - cz * 16 + 1)
        for cx in range(target_bounds["min_x"] // 16, target_bounds["max_x"] // 16 + 1):
            x0 = max(0, target_bounds["min_x"] - cx * 16)
            x1 = min(16, target_bounds["max_x"] - cx * 16 + 1)
            for sy in range(-4, 20):
                palette, array = target.get_section(cx, cz, sy)
                used = np.bincount(array[:, z0:z1, x0:x1].reshape(-1), minlength=len(palette))
                for state, count in zip(palette, used):
                    if not count:
                        continue
                    name = state["Name"]
                    counts[name] += int(count)
                    spec = block_report.get(name)
                    if spec is None or any(value not in spec.get("properties", {}).get(key, [])
                                           for key, value in state.get("Properties", {}).items()):
                        invalid.append(state)
    assert not invalid, f"Invalid 1.20.1 block states: {invalid[:8]}"
    for forbidden in ("command_block", "chain_command_block", "repeating_command_block", "spawner"):
        assert counts["minecraft:" + forbidden] == 0, f"Old machinery retained: {forbidden}"
    solids = sum(n for name, n in counts.items() if name not in ("minecraft:air", "minecraft:cave_air", "minecraft:void_air"))
    natural = sum(n for name, n in counts.items() if is_natural(name))
    assert natural / solids >= 0.95, f"Natural materials only {natural/solids:.1%}"
    landmarks = layout["landmarks"]
    checked = []
    for name in ("town_return", "portal"):
        x, y, z = (math.floor(value) for value in landmarks[name])
        below = target.get_block(x, y - 1, z)["Name"]
        feet = target.get_block(x, y, z)["Name"]
        head = target.get_block(x, y + 1, z)["Name"]
        assert below not in ("minecraft:air", "minecraft:water", "minecraft:lava"), (name, "no floor", below)
        assert feet in ("minecraft:air", "minecraft:cave_air") and head in ("minecraft:air", "minecraft:cave_air"), (name, "blocked landing", feet, head)
        checked.append({"name": name, "feet": [x, y, z], "floor": below})
    return {
        "pass": True, "source_blocks_unchanged": source_voxels,
        "source_area": width * depth, "shadow_area": (target_bounds["max_x"] - target_bounds["min_x"] + 1) * depth,
        "natural_non_air_ratio": natural / solids, "non_air_blocks": solids,
        "checked_landings": checked, "palette_counts": dict(counts.most_common()),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-world", type=Path, required=True)
    parser.add_argument("--target-world", type=Path, required=True)
    parser.add_argument("--blocks-report", type=Path, required=True)
    parser.add_argument("--layout", type=Path, default=Path(__file__).resolve().parents[1] / "shadow_layout.json")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = inspect(WorldEditor(args.source_world), WorldEditor(args.target_world),
                     json.loads(args.layout.read_text(encoding="utf8")),
                     json.loads(args.blocks_report.read_text(encoding="utf8")))
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf8")
    print(json.dumps({key: value for key, value in result.items() if key != "palette_counts"}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
