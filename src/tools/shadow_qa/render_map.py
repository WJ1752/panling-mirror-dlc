"""Render terrain data for map review; these are block-map previews, not game screenshots."""

import argparse
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from mca_editor import WorldEditor


def color(name):
    block = name.split(":")[-1]
    if block in ("snow", "snow_block", "calcite", "white_wool"):
        return (214, 223, 227)
    if block == "light_gray_wool":
        return (148, 149, 153)
    if block == "water":
        return (53, 94, 122)
    if block == "lava":
        return (195, 80, 27)
    if "terracotta" in block:
        return (89, 87, 96) if "gray" in block else (147, 119, 97)
    if any(k in block for k in ("deepslate", "blackstone", "obsidian", "bedrock")):
        return (64, 72, 85)
    if "tuff" in block:
        return (119, 126, 125)
    if "leaves" in block:
        return (66, 89, 78)
    if any(k in block for k in ("lantern", "glowstone")):
        return (122, 211, 218)
    if "glass" in block:
        return (110, 136, 151)
    if "wood" in block or "log" in block:
        return (101, 87, 76)
    return (142, 150, 159)


def surfaces(world, bounds):
    x0, x1, z0, z1 = bounds
    height = np.full((z1-z0+1, x1-x0+1), -65, dtype=np.int16)
    rgb = np.zeros((*height.shape, 3), dtype=np.uint8)
    for cz in range(z0//16, z1//16+1):
        for cx in range(x0//16, x1//16+1):
            h = np.full((16, 16), -65, dtype=np.int16)
            colors = np.zeros((16, 16, 3), dtype=np.uint8)
            for sy in range(19, -5, -1):
                palette, array = world.get_section(cx, cz, sy)
                opaque = np.array([p["Name"] not in ("minecraft:air", "minecraft:cave_air", "minecraft:void_air", "minecraft:barrier", "minecraft:light") for p in palette])
                masks = opaque[array]
                valid = masks.any(axis=0) & (h == -65)
                if not valid.any():
                    continue
                ys = 15 - masks[::-1].argmax(axis=0)
                zz, xx = np.where(valid)
                h[zz, xx] = sy*16 + ys[zz, xx]
                colors[zz, xx] = np.asarray([color(p["Name"]) for p in palette], dtype=np.uint8)[array[ys[zz, xx], zz, xx]]
            a, b = max(x0, cx*16), min(x1+1, cx*16+16)
            c, d = max(z0, cz*16), min(z1+1, cz*16+16)
            height[c-z0:d-z0, a-x0:b-x0] = h[c-cz*16:d-cz*16, a-cx*16:b-cx*16]
            rgb[c-z0:d-z0, a-x0:b-x0] = colors[c-cz*16:d-cz*16, a-cx*16:b-cx*16]
    dy, dx = np.gradient(np.maximum(height, 0).astype(float))
    lighting = np.clip(.92 + .035*dx + .025*dy, .50, 1.25)
    lighting *= np.clip(.65 + np.maximum(height, 0)*.002, .65, 1.1)
    rgb = np.clip(rgb*lighting[:, :, None], 0, 255).astype(np.uint8)
    rgb[height == -65] = (19, 27, 39)
    return height, rgb


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--world", type=Path, required=True)
    parser.add_argument("--layout", type=Path, default=Path(__file__).resolve().parents[1] / "shadow_layout.json")
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    layout = json.loads(args.layout.read_text(encoding="utf8"))
    profile = layout["sources"][layout["selected_source"]]
    original = profile["bounds"]
    shadow = profile["target_bounds"]
    world = WorldEditor(args.world)
    bounds = shadow["min_x"], original["max_x"], original["min_z"], original["max_z"]
    height, rgb = surfaces(world, bounds)
    image = Image.fromarray(rgb).resize((rgb.shape[1]*2, rgb.shape[0]*2), Image.Resampling.NEAREST)
    draw = ImageDraw.Draw(image)
    draw.line((2*(shadow["max_x"]-shadow["min_x"])+1, 0, 2*(shadow["max_x"]-shadow["min_x"])+1, image.height), fill=(83, 173, 197), width=2)
    draw.text((20, 16), "SHADOW / natural stone mirror", fill=(231, 243, 250))
    draw.text((image.width//2+20, 16), "ORIGINAL / unchanged", fill=(231, 243, 250))
    for title, coords, tint in [("Town", layout["landmarks"]["town_return"], (86, 224, 223)), ("Boss portal", layout["landmarks"]["portal"], (239, 209, 131))]:
        x, _, z = coords
        u, v = int((x-bounds[0])*2), int((z-bounds[2])*2)
        draw.ellipse((u-5, v-5, u+5, v+5), outline=tint, width=2)
        draw.text((u+9, v), title, fill=tint)
    image.save(args.output_dir / "mountain-pair.png")
    town = (-731, -680, -1481, -1429)
    _, rgb = surfaces(world, town)
    Image.fromarray(rgb).resize((832, 848), Image.Resampling.NEAREST).save(args.output_dir / "town-top.png")
    # Column-based axonometric review of the installed settlement. Caves and
    # interiors require in-game inspection; this preview shows roofs and streets.
    h, rgb = surfaces(world, town)
    canvas = Image.new("RGB", (1080, 850), (19, 27, 39))
    pen = ImageDraw.Draw(canvas)
    for zz, xx in sorted(np.ndindex(h.shape), key=lambda p: p[0]+p[1]):
        y = int(h[zz, xx])
        if y < 170:
            continue
        u = 540 + (xx-zz)*8
        v = 170 + (xx+zz)*4 - (y-195)*8
        col = tuple(int(n) for n in rgb[zz, xx])
        bottom = max(180, min(y, int(h[max(0, zz-1), xx]), int(h[zz, max(0, xx-1)])))
        drop = min(80, (y-bottom)*8)
        if drop:
            pen.polygon([(u-8,v),(u,v+4),(u,v+4+drop),(u-8,v+drop)], fill=tuple(int(c*.65) for c in col))
            pen.polygon([(u,v+4),(u+8,v),(u+8,v+drop),(u,v+4+drop)], fill=tuple(int(c*.80) for c in col))
        pen.polygon([(u,v-4),(u+8,v),(u,v+4),(u-8,v)], fill=col)
    pen.text((28, 28), "SHADOW TOWN / installed block geometry", fill=(224, 236, 247))
    pen.text((28, 48), "Data preview; not an in-game screenshot", fill=(133, 155, 177))
    canvas.save(args.output_dir / "town-isometric.png")
    print(args.output_dir.resolve())


if __name__ == "__main__":
    main()
