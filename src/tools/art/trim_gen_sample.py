# -*- coding: utf-8 -*-
"""
trim_gen_sample —— 生成《镜中倒影》盔甲底甲 + 纹饰样例，并导出 trim_manifest.json

产出（全部在 out/ 下，不碰 src/resourcepack）：
  out/trim_ref/                              参考贴图（panling / vanilla）
  out/trim_sample/base_mirror_netherite_layer_1.png   128×64
  out/trim_sample/base_mirror_netherite_layer_2.png   128×64
  out/trim_sample/trim_zhao_layer_1.png               64×32（灰度）
  out/trim_sample/trim_zhao_leggings.png              64×32（灰度）
  out/trim_sample/palette_zhao.png                    8×1（深→浅）
  out/trim_sample/palette_key.png                     8×1（升序 0→224）
  out/trim_sample/armor_trims_plm_patch.json          atlas 追加片段
  out/trim_preview_sample.png                         一页式合成预览

用法：
  python -I src/tools/art/trim_gen_sample.py            # 生成样例 + 预览 + 自检
  python -I src/tools/art/trim_gen_sample.py --manifest # 顺带重写 trim_manifest.json
  python -I src/tools/art/trim_gen_sample.py --check    # 只校验 manifest 与模块一致性
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
from collections import OrderedDict

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import trim_art as A
import gen_netherite_base as G   # 底甲样例改由正式生成器产出，保证 sample 与最终文件同源

OUT_SAMPLE = os.path.join(A.OUT_ROOT, "trim_sample")
PREVIEW = os.path.join(A.OUT_ROOT, "trim_preview_sample.png")
MANIFEST = os.path.join(A.HERE, "trim_manifest.json")

ATLAS_SHA1 = "b2e64a676161bd61567dd59a6e0d93ead6d1a52d"

MOTIF_RECIPES = {
    "zhao": "外环 r=2.6（1px）+ 内环 r=1（阴影灰）+ 中心 1px 亮点；盔顶 r=2.0；"
            "甲带为双线 + 每 4px 一颗亮点。",
    "lie": "45° 主折线 3 段（抖动 1px）+ 1 条偏移阴影线 + 2 个 1–2px 碎片；"
           "甲带用 2on2off 虚线 + 1on3off 阴影线。",
    "jing": "5 个 r≈1.1 的花瓣环（间距 72°）+ 中心 1px 花心 + 下方 20°–160° 水月弧；"
            "甲带为 1on2off 点线 + 每 5px 一个弧点。",
    "can": "两个 r=2.6 的圆环，圆心错位 (+1,+1)，一亮一暗；左侧 2 条 3px 速度线；"
           "甲带为双行错位虚线（上 3on2off / 下偏移 1px）。",
    "twin": "菱形 r=2.6 沿中轴切半：左半高灰度（浅端=金）、右半低灰度（深端=蓝）；"
            "中轴 1px 浅线 + 上下双点（一亮一暗）；甲带左金右蓝、上下行互换。",
    "rub": "5×5 方印框（1px）+ 3 横 1 竖印纹 + 框外 2 个纸纤维点；"
           "甲带用 2on1off 短划 + 两端墨点。",
}

GRAY_ROLE_CN = {"line": "主线", "shadow": "阴影/副线", "spark": "高光/点"}


# ---------------------------------------------------------------- manifest

def build_manifest():
    """DEPRECATED：旧样例结构；manifest 的写入走 gen_trims.write_manifest()。"""
    sets = OrderedDict()
    for k in A.SET_ORDER:
        st = A.SETS[k]
        t1 = A.build_trim(k, 1)
        t2 = A.build_trim(k, 2)
        a1 = A.audit_trim(t1.to_image(), 1) if False else None
        cols = A.palette_colors(k)
        lums = [round(A.luminance(c), 1) for c in cols]
        sets[k] = OrderedDict([
            ("key", k),
            ("name", st["name"]),
            ("armor_set", st["armor"]),
            ("motif", st["motif"]),
            ("motif_cn", st["motif_cn"]),
            ("motif_recipe", MOTIF_RECIPES[k]),
            ("accent", st["accent"]),
            ("accent_dark", st["accent_dark"]),
            ("gray_roles", {role: {"gray": g, "role_cn": GRAY_ROLE_CN[role]}
                            for role, g in st["gray_roles"].items()}),
            ("palette", OrderedDict([
                ("texture", "assets/plm/textures/trims/color_palettes/%s.png" % k),
                ("resource_location", "plm:trims/color_palettes/%s" % k),
                ("size", [8, 1]),
                ("order", "dark_to_light"),
                ("colors", ["#%02X%02X%02X" % c for c in cols]),
                ("luminance", lums),
            ])),
            ("pattern", OrderedDict([
                ("layer_1", OrderedDict([
                    ("texture", "assets/plm/textures/trims/models/armor/%s.png" % k),
                    ("resource_location", "plm:trims/models/armor/%s" % k),
                    ("size", [64, 32]),
                ])),
                ("leggings", OrderedDict([
                    ("texture", "assets/plm/textures/trims/models/armor/%s_leggings.png" % k),
                    ("resource_location", "plm:trims/models/armor/%s_leggings" % k),
                    ("size", [64, 32]),
                ])),
            ])),
            ("base", OrderedDict([
                ("shared", True),
                ("layer_1", "assets/minecraft/textures/models/armor/netherite_layer_1.png"),
                ("layer_2", "assets/minecraft/textures/models/armor/netherite_layer_2.png"),
            ])),
            ("trim", OrderedDict([
                ("pattern_id", "plm:%s" % k),
                ("material_id", "plm:%s" % k),
                ("nbt", '{Trim:{pattern:"plm:%s",material:"plm:%s"}}' % (k, k)),
            ])),
            ("lang", OrderedDict([
                ("pattern_key", "trim_pattern.plm.%s" % k),
                ("material_key", "trim_material.plm.%s" % k),
                ("pattern_zh", "%s纹" % st["name"]),
                ("material_zh", st["armor"]),
            ])),
            ("coverage", OrderedDict([
                ("layer_1", round(t1.coverage(), 4)),
                ("leggings", round(t2.coverage(), 4)),
            ])),
            ("gray_values", sorted({px[0] for y in range(32) for x in range(64)
                                    for px in [t1.im.load()[x, y]] if px[3]})),
        ])

    placement = OrderedDict([
        ("layer_1", OrderedDict([
            ("helmet_crown", {"box": [8, 0, 8, 8], "anchor": [11.5, 3.5], "r": 2.0,
                              "sentry": "x=11..12, y=0..7（中脊）"}),
            ("helmet_brow", {"box": [8, 9, 8, 1], "anchor": [11.5, 9.0], "r": None,
                             "sentry": "y=8..10（额带；y11..15 为面甲开口，禁止）"}),
            ("helmet_back", {"box": [27, 8, 2, 6], "anchor": [27.5, 10.5], "r": None,
                             "sentry": "x=27..28, y=8..13"}),
            ("shoulder_top", {"box": [44, 16, 4, 4], "anchor": [45.5, 17.5], "r": 1.6,
                              "sentry": "x=44..45, y=17..18"}),
            ("shoulder_ring", {"box": [40, 22, 16, 1], "anchor": [47.5, 22.0], "r": None,
                               "sentry": "x=40..45, y=20..22"}),
            ("chest_front", {"box": [20, 20, 8, 12], "anchor": [23.5, 26.2], "r": 2.6,
                             "sentry": "x=21..26, y=23..28"}),
            ("boot_band", {"box": [0, 26, 16, 2], "anchor": [7.5, 26.0], "r": None,
                           "sentry": "x=2..9, y=26..27"}),
        ])),
        ("layer_2", OrderedDict([
            ("thigh_band", {"box": [0, 23, 16, 1], "anchor": [7.5, 23.0], "r": None,
                            "sentry": "sentry_leggings x=0..15, y=22..25"}),
            ("waist_front", {"box": [20, 20, 8, 12], "anchor": [23.5, 25.0], "r": 2.4,
                             "sentry": "腿甲前腰（sentry_leggings 未用，属本 DLC 追加）"}),
            ("knee_band", {"box": [0, 29, 16, 1], "anchor": [7.5, 29.0], "r": None,
                           "sentry": "膝下带（sentry_leggings 未用）"}),
        ])),
    ])

    lang = OrderedDict()
    for k in A.SET_ORDER:
        st = A.SETS[k]
        lang["trim_pattern.plm.%s" % k] = "%s纹" % st["name"]
        lang["trim_material.plm.%s" % k] = st["armor"]

    manifest = OrderedDict([
        ("schema", "mirror-trim-manifest/1"),
        ("project", "梦回盘灵：镜中倒影"),
        ("version", "1.0.0"),
        ("generated_by", "src/tools/art/trim_gen_sample.py --manifest（数据源：trim_art.SETS）"),
        ("single_source_of_truth", True),
        ("resourcepack_root", "src/resourcepack"),
        ("namespace", "plm"),
        ("carrier", "minecraft:netherite_helmet / chestplate / leggings / boots"),
        ("canvas", OrderedDict([
            ("base", {"size": [128, 64], "mode": "RGBA", "alpha": "binary (0/255)",
                      "outline": "alpha 严格等于 vanilla netherite_layer_* 的 2× 放大"}),
            ("trim", {"size": [64, 32], "mode": "RGBA", "alpha": "binary (0/255)",
                      "gray_levels": list(A.GRAYS)}),
        ])),
        ("rules", OrderedDict([
            ("base_palette", list(A.MIRROR_HEX)),
            ("base_max_pure_white_ratio", 0.02),
            ("base_max_cyan_ratio", 0.02),
            ("trim_max_coverage", A.MAX_TRIM_COVERAGE),
            ("trim_min_coverage", A.MIN_TRIM_COVERAGE),
            ("trim_only_gray_values", list(A.GRAYS)),
            ("trim_line_width_px", 1),
            ("trim_must_stay_inside_netherite_alpha", True),
            ("do_not_touch", "src/resourcepack/**"),
        ])),
        ("palette", OrderedDict([
            ("size", [8, 1]),
            ("order", "dark_to_light"),
            ("key", OrderedDict([
                ("texture", "assets/plm/textures/trims/color_palettes/key.png"),
                ("resource_location", "plm:trims/color_palettes/key"),
                ("values", list(A.GRAYS)),
                ("order", "ascending 0→224"),
            ])),
            ("why_custom_key",
             "原版 trim_palette 索引 0=224、7=0；本规范调色板按“深→浅”落盘。"
             "若用原版 key，224 会映射到最深夜色，明暗反转。升序 key 让 gray/32 直接等于索引，"
             "既满足“深→浅”的交付要求，也保证游戏内亮度正确。"),
        ])),
        ("atlas", OrderedDict([
            ("path", "assets/minecraft/atlases/armor_trims.json"),
            ("vanilla_sha1", ATLAS_SHA1),
            ("operation", "append_source"),
            ("preserve_vanilla_source", True),
            ("source_count_after", 2),
            ("source", A.atlas_source("plm")),
            ("patch_file", "out/trim_sample/armor_trims_plm_patch.json"),
        ])),
        ("base", OrderedDict([
            ("shared", True),
            ("layer_1", {"texture": "assets/minecraft/textures/models/armor/netherite_layer_1.png",
                         "size": [128, 64], "sample": "out/trim_sample/base_mirror_netherite_layer_1.png"}),
            ("layer_2", {"texture": "assets/minecraft/textures/models/armor/netherite_layer_2.png",
                         "size": [128, 64], "sample": "out/trim_sample/base_mirror_netherite_layer_2.png"}),
            ("style", OrderedDict([
                ("ramp", list(A.MIRROR_HEX)),
                ("light", "左上"),
                ("seams", "UV 面倒角 1px + 甲片横缝 1px；窄面（<6px）不画竖倒角"),
                ("glints", "3 条 2–3px 斜线 #F4FBFF，≤2% 覆盖"),
                ("forbidden", ["大面积青色发光", "外部扩边改变 alpha", "把六套强调色烤进底甲"]),
            ])),
            ("note", "六套共用同一张底甲；差异化 100% 由 trim pattern + palette 承担。"
                     "最终底甲由 gen_netherite_base.py 生成（build 2026-11-03，"
                     "sha1 L1 064c1576bbc2cd64 / L2 3e054815f8117908），sample 与最终文件同源。"),
        ])),
        ("placement", placement),
        ("sets", sets),
        ("lang", lang),
        ("lang_file", "assets/plm/lang/zh_cn.json"),
        ("integration", OrderedDict([
            ("nbt_example", '{Trim:{pattern:"plm:zhao",material:"plm:zhao"}}'),
            ("trim_pattern_json", OrderedDict([
                ("asset_id", "plm:trims/models/armor/zhao"),
                ("description", {"translate": "trim_pattern.plm.zhao"}),
                ("template_item", "minecraft:netherite_upgrade_smithing_template"),
                ("decals", False),
            ])),
            ("trim_material_json", OrderedDict([
                ("asset_name", "zhao"),
                ("description", {"translate": "trim_material.plm.zhao"}),
                ("ingredient", "minecraft:netherite_ingot"),
                ("item_model_index", 0.1),
            ])),
            ("template_note", "pattern/material 的 template_item / ingredient 为占位；"
                              "集成时替换为 DLC 的镜铸模板与镜胚材料，不影响贴图路径。"),
            ("item_model_index_step", 0.1),
        ])),
        ("checks", [
            "python -I src/tools/art/trim_gen_sample.py",
            "python -I src/tools/art/trim_gen_sample.py --check",
            "python -I src/tools/art/trim_art.py --audit out/trim_sample/trim_zhao_layer_1.png --kind trim --layer 1",
            "python -I src/tools/art/trim_art.py --audit out/trim_sample/base_mirror_netherite_layer_1.png --kind base --layer 1",
            "python -I src/tools/art/trim_art.py --audit out/trim_sample/palette_zhao.png --kind palette",
        ]),
    ])
    return manifest


def write_manifest(path=MANIFEST):
    """manifest 必须由落盘 PNG 生成（gen_trims 是唯一写入者）。"""
    import gen_trims as G
    G.write_manifest(path)
    print("manifest  %s  (coverage/gray_roles/placement from disk)" % path)
    return path


# ---------------------------------------------------------------- 预览

def _panel(img, scale):
    if img.mode != "RGBA":
        img = img.convert("RGBA")
    return img.resize((img.width * scale, img.height * scale), Image.NEAREST)


def _label(d, xy, text, font):
    d.text(xy, text, font=font, fill=(214, 226, 236, 255))


def build_preview(base1, base2, t1, t2, c1, c2, pal, key, doll, out_path=PREVIEW):
    title_font = A._font(26, bold=True)
    sub_font = A._font(15)
    lab_font = A._font(14)
    cell_w, cell_h = 560, 330
    W, H = cell_w * 3 + 40, 78 + cell_h * 3 + 20
    out = A._checker(W, H, 10)
    d = ImageDraw.Draw(out)
    d.text((24, 14), "镜中倒影 · 盔甲底甲 + 纹饰样例（照心）", font=title_font,
           fill=(240, 247, 252, 255))
    d.text((24, 46), "底甲 128×64 RGBA · 纹饰 64×32 RGBA · 纹饰仅用 8 个灰度值 · 预览为最近邻放大",
           font=sub_font, fill=(150, 168, 184, 255))

    cells = [
        ("底甲 netherite_layer_1 · 128×64（4×）", base1, 4),
        ("纹饰 照心 layer_1 · 64×32 灰度（8×）", t1.convert("RGBA"), 8),
        ("合成 layer_1 · 128×64（4×）", c1, 4),
        ("底甲 netherite_layer_2 · 128×64（4×）", base2, 4),
        ("纹饰 照心 leggings · 64×32 灰度（8×）", t2.convert("RGBA"), 8),
        ("合成 layer_2 · 128×64（4×）", c2, 4),
        ("调色板 照心 · 8×1 深→浅（64×8）", pal.resize((64, 8), Image.NEAREST), 8),
        ("palette_key · 8×1 升序 0→224（64×8）", key.resize((64, 8), Image.NEAREST), 8),
        ("纸偶预览 · 底甲+纹饰（8×）", doll, 8),
    ]
    for i, (label, img, scale) in enumerate(cells):
        cx = 24 + (i % 3) * cell_w
        cy = 82 + (i // 3) * cell_h
        d.rectangle([cx, cy, cx + cell_w - 24, cy + cell_h - 22],
                    outline=(66, 80, 95, 255), width=1)
        big = _panel(img, scale)
        # 限制在格子内
        max_w, max_h = cell_w - 56, cell_h - 80
        if big.width > max_w or big.height > max_h:
            k = min(max_w / big.width, max_h / big.height)
            big = big.resize((max(1, int(big.width * k)), max(1, int(big.height * k))), Image.NEAREST)
        if big.mode != "RGBA":
            big = big.convert("RGBA")
        out.alpha_composite(big, (cx + 22, cy + 16))
        _label(d, (cx + 22, cy + cell_h - 52), label, lab_font)
        if i in (0, 3):
            _label(d, (cx + 22, cy + cell_h - 34),
                   "alpha = vanilla netherite ×2（2796 px / 1088 px）", A._font(12))
        if i in (1, 4):
            im = t1 if i == 1 else t2
            ip = im.convert("RGBA").load()
            cov = sum(1 for y in range(32) for x in range(64) if ip[x, y][3]) / 2048.0
            grays = sorted({ip[x, y][0] for y in range(32) for x in range(64) if ip[x, y][3]})
            _label(d, (cx + 22, cy + cell_h - 34),
                   "覆盖率 %.2f%% · 灰度 %s · 1px 线" % (cov * 100, grays),
                   A._font(12))
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    out.save(out_path)
    print("preview   %s  %dx%d" % (os.path.relpath(out_path, A.PROJECT_ROOT), out.width, out.height))
    return out_path


# ---------------------------------------------------------------- 校验

def check_manifest(path=MANIFEST):
    m = json.load(open(path, encoding="utf-8"))
    errs = []
    if m["schema"] != "mirror-trim-manifest/1":
        errs.append("schema")
    if set(m["sets"]) != set(A.SET_ORDER):
        errs.append("sets keys != SET_ORDER")
    for k in A.SET_ORDER:
        s = m["sets"][k]
        if s["palette"]["colors"] != ["#%02X%02X%02X" % c for c in A.palette_colors(k)]:
            errs.append("%s palette colors mismatch" % k)
        if s["pattern"]["layer_1"]["resource_location"] != "plm:trims/models/armor/%s" % k:
            errs.append("%s pattern id" % k)
        if s["lang"]["pattern_key"] != "trim_pattern.plm.%s" % k:
            errs.append("%s lang pattern" % k)
        if s["lang"]["material_key"] != "trim_material.plm.%s" % k:
            errs.append("%s lang material" % k)
    if m["atlas"]["source"]["palette_key"] != "plm:trims/color_palettes/key":
        errs.append("atlas palette_key")
    try:
        import gen_trims as G
        errs.extend(G.manifest_errors(path))
    except Exception as exc:  # noqa: BLE001
        errs.append("gen_trims manifest check: %r" % (exc,))
    print("check     manifest %s" % ("OK" if not errs else "FAIL: " + "; ".join(errs)))
    return not errs


# ---------------------------------------------------------------- main

def main(argv=None):
    ap = argparse.ArgumentParser(description="镜中倒影盔甲纹饰样例生成器")
    ap.add_argument("--manifest", action="store_true", help="重写 trim_manifest.json")
    ap.add_argument("--check", action="store_true", help="只校验 manifest")
    args = ap.parse_args(argv)

    if args.manifest:
        write_manifest()
    if args.check:
        ok = check_manifest()
        return 0 if ok else 1

    os.makedirs(OUT_SAMPLE, exist_ok=True)
    A.extract_references(verbose=False)
    print("refs      out/trim_ref/ (panling 8 + vanilla 7)")

    base1 = G.build(1)
    base2 = G.build(2)
    p1 = base1.save(os.path.join(OUT_SAMPLE, "base_mirror_netherite_layer_1.png"))
    p2 = base2.save(os.path.join(OUT_SAMPLE, "base_mirror_netherite_layer_2.png"))

    t1 = A.build_trim("zhao", 1)
    t2 = A.build_trim("zhao", 2)
    q1 = t1.save(os.path.join(OUT_SAMPLE, "trim_zhao_layer_1.png"))
    q2 = t2.save(os.path.join(OUT_SAMPLE, "trim_zhao_leggings.png"))

    pal_path = A.save_palette("zhao", os.path.join(OUT_SAMPLE, "palette_zhao.png"))
    key_path = A.save_palette_key(os.path.join(OUT_SAMPLE, "palette_key.png"))

    patch = {
        "file": "assets/minecraft/atlases/armor_trims.json",
        "operation": "append_source",
        "vanilla_sha1": ATLAS_SHA1,
        "note": "保留原 sources[0] 不动；把 source 追加到 sources 数组末尾。",
        "source": A.atlas_source("plm"),
    }
    patch_path = os.path.join(OUT_SAMPLE, "armor_trims_plm_patch.json")
    with open(patch_path, "w", encoding="utf-8") as fh:
        json.dump(patch, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    c1 = A.composite(base1, t1, "zhao")
    c2 = A.composite(base2, t2, "zhao")
    c1.save(os.path.join(OUT_SAMPLE, "composite_zhao_layer_1.png"))
    c2.save(os.path.join(OUT_SAMPLE, "composite_zhao_layer_2.png"))
    doll = A.paper_doll(c1, c2, scale=8)

    build_preview(base1.to_image(), base2.to_image(), t1.to_image(), t2.to_image(),
                  c1, c2, A.palette_image("zhao"), A.palette_key_image(), doll)

    # 自检
    checks = [
        ("base L1", A.audit_base(p1, 1), (128, 64)),
        ("base L2", A.audit_base(p2, 2), (128, 64)),
        ("trim L1", A.audit_trim(q1, 1), (64, 32)),
        ("trim L2", A.audit_trim(q2, 2), (64, 32)),
        ("palette", A.audit_palette(pal_path), (8, 1)),
        ("key", A.audit_palette(key_path), (8, 1)),
    ]
    ok = True
    for name, res, size in checks:
        if tuple(res["size"]) != size:
            ok = False
        ok = ok and res["ok"]
        extra = ""
        if "coverage" in res:
            extra = " cov=%.2f%%" % (res["coverage"] * 100)
        print("audit     %-8s %-10s %s%s" % (name, "%dx%d" % tuple(res["size"]),
                                             "PASS" if res["ok"] else "FAIL", extra))
        for e in res.get("errors", []):
            print("          ! " + e)
    print("sample    %s" % os.path.relpath(OUT_SAMPLE, A.PROJECT_ROOT))
    print("result    %s" % ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
