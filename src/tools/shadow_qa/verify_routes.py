"""Check real two-block headroom and walking connections from town to wilderness."""

import argparse
import json
import math
import sys
from collections import deque
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from mca_editor import WorldEditor


def check_routes(world, layout):
    bounds = layout["sources"][layout["selected_source"]]["target_bounds"]
    x0, z0 = bounds["min_x"], bounds["min_z"]
    width, depth = bounds["max_x"] - x0 + 1, bounds["max_z"] - z0 + 1
    solid = np.zeros((384, depth, width), dtype=bool)
    air = np.ones_like(solid)
    for cz in range(z0 // 16, bounds["max_z"] // 16 + 1):
        za, zb = max(z0, cz*16), min(bounds["max_z"]+1, cz*16+16)
        for cx in range(x0 // 16, bounds["max_x"] // 16 + 1):
            xa, xb = max(x0, cx*16), min(bounds["max_x"]+1, cx*16+16)
            for sy in range(-4, 20):
                palette, array = world.get_section(cx, cz, sy)
                empty = np.asarray([state["Name"] in ("minecraft:air", "minecraft:cave_air", "minecraft:void_air", "minecraft:light") for state in palette])
                floor = np.asarray([not state["Name"].endswith(("air", "water", "lava", "lantern", "torch", "leaves", "carpet", "grass", "fern")) and state["Name"] != "minecraft:light" for state in palette])
                sub = array[:, za-cz*16:zb-cz*16, xa-cx*16:xb-cx*16]
                a, b = (sy+4)*16, (sy+5)*16
                solid[a:b, za-z0:zb-z0, xa-x0:xb-x0] = floor[sub]
                air[a:b, za-z0:zb-z0, xa-x0:xb-x0] = empty[sub]
    walking = np.zeros_like(solid)
    walking[1:-1] = solid[:-2] & air[1:-1] & air[2:]
    del solid
    def local(coords):
        x, y, z = (math.floor(float(v)) for v in coords)
        return y+64, z-z0, x-x0
    start = local(layout["landmarks"]["town_return"])
    assert walking[start], f"Town landing is not walkable: {start}"
    targets = {local(point["feet"]): str(point["id"]) for point in layout["landmarks"]["wilderness_spawn_points"]}
    targets[local(layout["landmarks"]["portal"])] = "boss_portal"
    for point, name in targets.items():
        assert walking[point], f"Target {name} lacks a floor or two-block headroom"
    seen = np.zeros_like(walking)
    seen[start] = True
    queue = deque([(start, 0)])
    reached = {}
    while queue and len(reached) < len(targets):
        (y, z, x), distance = queue.popleft()
        if (y, z, x) in targets:
            reached[targets[y, z, x]] = distance
        for zz, xx in ((z-1,x), (z+1,x), (z,x-1), (z,x+1)):
            if not (0 <= zz < depth and 0 <= xx < width):
                continue
            for yy in (y, y+1, y-1):
                if not (1 <= yy < 383) or not walking[yy, zz, xx] or seen[yy, zz, xx]:
                    continue
                # A raised step also needs room over the previous cell; a drop
                # needs a clear vertical column beside the ledge.
                if yy > y and not air[y+2, z, x]:
                    continue
                if yy < y and not air[yy:y+2, zz, xx].all():
                    continue
                seen[yy, zz, xx] = True
                queue.append(((yy, zz, xx), distance+1))
    missing = sorted(set(targets.values()) - set(reached))
    result = {"pass": not missing, "walking_steps": reached, "unreachable": missing,
              "visited_cells": int(seen.sum()), "rule": "two-block headroom; at most one block of ascent or descent"}
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--world", type=Path, required=True)
    parser.add_argument("--layout", type=Path, default=Path(__file__).resolve().parents[1] / "shadow_layout.json")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = check_routes(WorldEditor(args.world), json.loads(args.layout.read_text(encoding="utf8")))
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf8")
    print(json.dumps(result, ensure_ascii=False, indent=2))
    if not result["pass"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
