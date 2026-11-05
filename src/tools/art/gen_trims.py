# -*- coding: utf-8 -*-
"""
gen_trims —— 《梦回盘灵：镜中倒影》六套盔甲纹饰（armor trim）正式落盘

范围（规范 §4 / §5 / §6.1）：
  * 6 套 × 2 层 = 12 张 pattern，64×32 RGBA，只用 trim_palette 的 8 个灰度值：
        src/resourcepack/assets/plm/textures/trims/models/armor/<set>.png
        src/resourcepack/assets/plm/textures/trims/models/armor/<set>_leggings.png
  * 6 张 palette，8×1，索引 0=最深 → 7=最浅：
        .../color_palettes/<set>.png
  * 1 张升序 key（§4.7 必需）：.../color_palettes/key.png
  * 1 张预览，六套 × 共用底甲合成，4×：out/trim_patterns_preview.png
  * 从落盘 PNG 重算 trim_manifest.json（coverage / gray_roles / placement）。

审读修正（2026-11-03）：
  1. 预览读取“当前”底甲：_load_base() 做 audit_base + sha1；预览写入
     plm_base_l1_sha1 / plm_base_l2_sha1 / plm_build_time；--check 逐面板
     比对“当前底甲 + 当前落盘 trim”的 4× 合成，底甲一换就 FAIL。
  2. manifest 由落盘 PNG 重算，不再由旧 trim_art.SETS 生成；同步 layer_2
     waist/knee 放置区。
  3. 修盔顶中脊透出：zhao/jing/rub 冠心补 1px 160 中灰。
  4. zhao 冠改 r=2.5 空心环 + 上下短脊；胸心内环改 r=1.6 空心环，删散点涟漪。
  5. lie 胸心改 2 段折痕 + 单端阴影 + 1px 碎片；冠改短折痕。
  6. jing 花瓣改 160 + 192 五边形连线；腿带加密。
  7. can 冠改 x=10/x=12 留 1px；速度线缩为 2px 并与环留空。
  8. 六套都引入 160 中色；rub 128 朱红框 + 64 墨 + 160 印心 + 192 纸色。
  9. 落盘文件与当前 painter 不一致时 --check 直接 FAIL。

注：规范 §0/A14 的“不碰 src/resourcepack”是样例阶段约束；本次按 ask 正式落盘。
    脚本只写 19 个 resourcepack 文件 + 1 张 out 预览 + 更新 trim_manifest.json。

用法：
  python -I src/tools/art/gen_trims.py            # 生成 + 预览 + manifest + 自检
  python -I src/tools/art/gen_trims.py --check    # 只读复检
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import math
import os
import sys
import time

from PIL import Image, ImageDraw
from PIL.PngImagePlugin import PngInfo

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import trim_art as A  # noqa: E402

PROJ = A.PROJECT_ROOT
PACK = os.path.join(PROJ, "src", "resourcepack")
PATTERN_DIR = os.path.join(PACK, "assets", "plm", "textures", "trims", "models", "armor")
PALETTE_DIR = os.path.join(PACK, "assets", "plm", "textures", "trims", "color_palettes")
BASE_DIR = os.path.join(PACK, "assets", "minecraft", "textures", "models", "armor")
PREVIEW = os.path.join(PROJ, "out", "trim_patterns_preview.png")
MANIFEST = os.path.join(HERE, "trim_manifest.json")

# 审读后每套至少 4 档，160（index 5）必须实际出现。
# can 以 160 为主线（#5FD6E8），192 作速度线高光；twin 右半 96（#4A78C0），
# 160 作菱形上下顶点过渡；rub 128 朱红框、64 墨、160 印心、192 纸色。
ROLES = {
    "zhao": {"line": 192, "mid": 160, "shadow": 96, "spark": 224},
    "lie":  {"line": 192, "mid": 160, "shadow": 128, "spark": 224},
    "jing": {"line": 192, "mid": 160, "shadow": 96, "spark": 224},
    "can":  {"line": 160, "mid": 192, "shadow": 96, "spark": 224},
    "twin": {"line": 224, "mid": 160, "shadow": 96, "spark": 192},
    "rub":  {"line": 128, "mid": 160, "shadow": 64, "spark": 192},
}
ROLE_CN = {"line": "主线", "mid": "中色/副亮", "shadow": "阴影/副线", "spark": "高光/点"}

RECIPES = {
    "zhao": "外环 r=2.6（192）+ 内环 r=1.6（160）+ 中心 1px 224；"
            "盔顶 r=2.5 环 + 上下 1px 短脊 + 160 中脊；甲带 192 主线 + 96 副线 + 每 4px 224。",
    "lie": "胸心 2 段折痕（192）+ 折点 160 + 单端 128 阴影 + 1px 224 碎片；"
           "盔顶 2 段短折痕 + 160/224 各 1px 碎片；甲带 2on1off 192 + 1on2off 128。",
    "jing": "5 个 160 花瓣点 + 192 五边形连线 + 1px 224 花心 + 96 底部投影；"
            "盔顶 r=2.0 环 + 160 中脊；甲带 2on1off 192 + 160 水月弧 + 96 端点。",
    "can": "160 主环 + (+1,+1) 96 偏移环；2 条 2px 192 速度线（与环留 1px）；"
           "盔顶 x=10 160 / x=12 96（中间留 1px）；甲带 3on2off 160 + 96 错位。",
    "twin": "菱形沿 x=cx 切半：左 192 金 / 右 96 蓝；中轴 224；上下顶点 160 过渡；"
            "左上 192 / 右下 96 双点；甲带左金右蓝、下一行交换。",
    "rub": "6×6 方框 128 朱红 + 64 墨纹 3 横 1 竖 + 160 印心 + 192 纸纤维；"
           "盔顶 5×5 框 + 160 中脊（盖住底甲中脊）+ 64 墨点；甲带 128 短划 + 64 墨点。",
}

SET_LABEL = {
    "zhao": "照心 · 同心圆 / 镜盘",
    "lie": "裂影 · 斜向折痕 + 碎片",
    "jing": "镜花 · 五瓣花 + 水月弧",
    "can": "残影 · 偏移双线 + 速度线",
    "twin": "双生 · 左右双半 + 双点",
    "rub": "拓印 · 方印边 + 纸纹",
}

# 规范 §4.3 的放置锚点（64×32 逻辑坐标）；layer_2 两处按实测遮罩修正
BROW_Y = 9
SHOULDER = (45.5, 17.5)
CHEST = (23.5, 26.2)
WAIST = (23.5, 29.0)
THIGH_Y = 23
KNEE_Y = 26
BOOT_MAIN_Y = 27
BOOT_ACCENT_Y = 26
SHOULDER_RING_Y = 22

# 预览版式（4× 面板；3 列 × 2 行）
SCALE = 4
PANEL_W, PANEL_H = 128 * SCALE, 64 * SCALE
CARD_W = PANEL_W
CARD_H = 58 + PANEL_H + 20 + 14 + PANEL_H + 20 + 10 + 26 + 18
MARGIN, GAP, HEAD, COLS = 24, 20, 74, 3


def _preview_size():
    w = MARGIN * 2 + CARD_W * COLS + GAP * (COLS - 1)
    h = HEAD + CARD_H * 2 + GAP + MARGIN
    return w, h


def _card_origin(i):
    return MARGIN + (i % COLS) * (CARD_W + GAP), HEAD + (i // COLS) * (CARD_H + GAP)


def _panel_origin(i, layer):
    cx, cy = _card_origin(i)
    py = cy + 58
    if layer == 2:
        py += PANEL_H + 20 + 14
    return cx, py


# ---------------------------------------------------------------- 徽记
def _flower_points(cx, cy, dist):
    pts = []
    for k in range(5):
        a = math.radians(-90 + 72 * k)
        pts.append((int(round(cx + dist * math.cos(a))),
                    int(round(cy + dist * math.sin(a)))))
    return pts


def _badge(c, key, cx, cy, r, compact=False):
    """胸心/肩顶/腰扣的母题徽记；compact 用于 4×4 肩顶与 5 行高的腰扣。"""
    line, mid = ROLES[key]["line"], ROLES[key]["mid"]
    shadow, spark = ROLES[key]["shadow"], ROLES[key]["spark"]
    kind = A.SETS[key]["motif"]
    ix, iy = int(round(cx)), int(round(cy))

    if kind == "rings":
        # 胸心只留外环 + 空心 + 1px spark；肩顶/腰扣用 160 环带中色
        ring_gray = mid if compact else line
        c.ring(cx, cy, r, ring_gray)
        c.put(cx, cy, spark)

    elif kind == "crack":
        if compact:
            c.line(cx - r, cy, cx + r, cy, line)
            c.put(cx, cy - 1, shadow)
            c.put(cx + 1, cy, mid)
            c.put(cx + r, cy, spark)
        else:
            c.polyline([(round(cx - r), round(cy - r)),
                        (round(cx - 0.5), round(cy)),
                        (round(cx + r), round(cy + r))], line)
            c.put(cx - 0.5, cy, mid)
            c.put(round(cx + r) - 1, round(cy + r) + 1, shadow)
            c.put(round(cx + r), round(cy + r) + 1, shadow)
            c.put(round(cx - r), round(cy - r - 1), spark)

    elif kind == "flower":
        if compact:
            c.petal_flower(cx, cy, r, mid, center_gray=spark)
        else:
            pts = _flower_points(cx, cy, 2.2)
            c.polyline(pts + [pts[0]], line)
            for px, py in pts:
                c.put(px, py, mid)
            c.put(cx, cy, spark)
            c.put(cx, cy + 3, shadow)

    elif kind == "ghost":
        if compact:
            c.line(cx, cy - r, cx, cy + r, line)
            c.line(cx + 2, cy - r + 1, cx + 2, cy + r, shadow)
            c.put(cx, cy, mid)
        else:
            c.ring(cx, cy, r, line)
            c.ring(cx + 1, cy + 1, r, shadow)
            c.line(cx - r - 1, 23, cx - r, 23, mid)
            c.line(cx - r - 1, 30, cx - r + 1, 30, mid)
            c.put(cx - r - 1, 23, spark)

    elif kind == "twin":
        rr = max(1, int(round(r)))
        if compact and r < 2.2:
            c.line(ix - 1, iy - 1, ix - 1, iy + 1, spark)
            c.line(ix + 1, iy - 1, ix + 1, iy + 1, shadow)
        else:
            for dy in range(-rr, rr + 1):
                half = rr - abs(dy)
                if half:
                    c.put(ix - half, iy + dy, spark)
                    c.put(ix + half, iy + dy, shadow)
            c.line(ix, iy - rr, ix, iy + rr, line)
            c.put(ix, iy - rr, mid)
            c.put(ix, iy + rr, mid)
            c.put(ix - 1, iy - rr + 2, spark)
            c.put(ix + 1, iy + rr - 2, shadow)

    elif kind == "stamp":
        if compact:
            c.rect_outline(ix - 1, iy - 1, ix + 1, iy + 1, line)
            c.put(ix, iy, mid)
            c.put(ix + 2, iy, spark)
        else:
            x0, y0, x1, y1 = 21, 23, 26, 28
            c.rect_outline(x0, y0, x1, y1, line)
            c.line(x0 + 1, y0 + 1, x1 - 1, y0 + 1, shadow)
            c.line(x0 + 1, y0 + 3, x0 + 2, y0 + 3, shadow)
            c.line(x1 - 2, y1 - 1, x1 - 1, y1 - 1, shadow)
            c.line(x0 + 3, y0 + 1, x0 + 3, y1 - 1, shadow)
            c.put(x0 + 4, y0 + 3, mid)
            c.put(x0 - 1, y1, spark)
            c.put(x1 + 1, y0, spark)

    else:
        raise ValueError("unknown motif %r" % kind)


# ---------------------------------------------------------------- 盔顶 / 眉线 / 后脑
def _crest(c, key):
    """头盔中脊（sentry 同位 x=11..12 / y=0..7）。"""
    line, mid = ROLES[key]["line"], ROLES[key]["mid"]
    shadow, spark = ROLES[key]["shadow"], ROLES[key]["spark"]
    kind = A.SETS[key]["motif"]

    if kind == "rings":
        # 5×5 空心环右移 1.5px：左缘 x=11 正好压住底甲中脊，中心只留 1px spark
        c.ring(13.0, 3.0, 2.0, line)
        c.put(13, 3, spark)
    elif kind == "crack":
        c.polyline([(10, 1), (12, 3), (11, 4)], line)
        c.put(12, 4, shadow)
        c.put(9, 5, mid)
    elif kind == "flower":
        c.ring(13.0, 3.0, 2.0, line)
        c.put(13, 3, spark)
        c.put(13, 6, shadow)
    elif kind == "ghost":
        c.line(10, 0, 10, 7, line)
        c.line(12, 1, 12, 7, shadow)
    elif kind == "twin":
        c.line(10, 0, 10, 7, spark)
        c.line(12, 0, 12, 7, shadow)
    elif kind == "stamp":
        c.rect_outline(11, 1, 15, 5, line)
        c.put(13, 3, mid)
        c.put(12, 2, shadow)
        c.put(14, 4, shadow)


def _brow(c, key):
    """眉线 y=9，只占 x9..14；y11..15 面甲开口禁止绘制。"""
    line, mid = ROLES[key]["line"], ROLES[key]["mid"]
    shadow, spark = ROLES[key]["shadow"], ROLES[key]["spark"]
    kind = A.SETS[key]["motif"]
    if kind == "twin":
        c.line(9, BROW_Y, 10, BROW_Y, spark)
        c.put(11, BROW_Y, line)
        c.line(12, BROW_Y, 14, BROW_Y, shadow)
    elif kind == "can":
        c.line(9, BROW_Y, 11, BROW_Y, line)
        c.line(12, BROW_Y, 14, BROW_Y, shadow)
    elif kind == "jing":
        c.dashed(9, BROW_Y, 14, BROW_Y, shadow, on=1, off=2)
    elif kind == "rub":
        c.dashed(9, BROW_Y, 14, BROW_Y, shadow, on=2, off=1)
    else:
        c.line(9, BROW_Y, 14, BROW_Y, shadow)


def _back(c, key):
    """后脑中线 x27..28 / y8..13（sentry 同位）。"""
    line, mid = ROLES[key]["line"], ROLES[key]["mid"]
    shadow, spark = ROLES[key]["shadow"], ROLES[key]["spark"]
    kind = A.SETS[key]["motif"]
    if kind == "twin":
        c.line(27, 8, 27, 13, shadow)
        c.line(28, 8, 28, 13, spark)
    elif kind == "crack":
        c.line(27, 8, 27, 13, shadow)
        c.line(28, 9, 28, 12, line)
    elif kind == "flower":
        for y in (8, 10, 12):
            c.put(27, y, shadow)
        for y in (9, 11, 13):
            c.put(28, y, line)
    elif kind == "ghost":
        c.line(27, 8, 27, 13, line)
        c.line(28, 9, 28, 13, shadow)
    else:
        c.line(27, 8, 27, 13, shadow)
        c.line(28, 9, 28, 12, line)


# ---------------------------------------------------------------- 甲带
def _band(c, key, x0, y, x1, compact=False):
    """1px 甲带；compact=True 时只画主行（膝带），保持稀疏。"""
    line, mid = ROLES[key]["line"], ROLES[key]["mid"]
    shadow, spark = ROLES[key]["shadow"], ROLES[key]["spark"]
    kind = A.SETS[key]["motif"]

    if kind == "rings":
        if compact:
            c.dashed(x0, y, x1, y, line, on=2, off=2)
            c.put(x0 + 1, y, spark)
            c.put(x1 - 1, y, spark)
        else:
            c.line(x0, y, x1, y, line)
            c.line(x0 + 2, y + 1, x1 - 2, y + 1, shadow)
            for x in range(x0 + 3, x1, 4):
                c.put(x, y, spark)

    elif kind == "crack":
        c.dashed(x0, y, x1, y, line, on=2, off=1)
        if not compact:
            c.dashed(x0 + 1, y + 1, x1, y + 1, shadow, on=1, off=2)

    elif kind == "flower":
        if compact:
            c.dashed(x0, y, x1, y, line, on=2, off=2)
        else:
            c.line(x0, y, x1, y, line)
        if not compact:
            for x in range(x0 + 1, x1 - 1, 5):
                c.put(x, y + 1, mid)
                c.put(x + 1, y + 1, mid)
            c.put(x0, y + 1, shadow)
            c.put(x1, y + 1, shadow)

    elif kind == "ghost":
        c.dashed(x0, y, x1 - 1, y, line, on=3, off=2)
        if not compact:
            c.dashed(x0 + 1, y + 1, x1, y + 1, shadow, on=3, off=2)
            c.put(x0, y, mid)
        else:
            c.put(x0 + 1, y, spark)

    elif kind == "twin":
        midx = (x0 + x1) // 2
        if compact:
            c.dashed(x0, y, midx, y, spark, on=2, off=2)
            c.dashed(midx + 1, y, x1, y, shadow, on=2, off=2)
        else:
            c.line(x0, y, midx, y, spark)
            c.line(midx + 1, y, x1, y, shadow)
            c.line(x0, y + 1, midx, y + 1, shadow)
            c.line(midx + 1, y + 1, x1, y + 1, spark)

    elif kind == "stamp":
        if compact:
            c.dashed(x0, y, x1, y, line, on=2, off=2)
            c.put(x0, y, shadow)
            c.put(x1, y, shadow)
            c.put((x0 + x1) // 2, y, mid)
        else:
            for x in range(x0, x1 + 1, 3):
                c.line(x, y, min(x + 1, x1), y, line)
            c.put(x0, y + 1, shadow)
            c.put(x1, y + 1, shadow)
            c.put((x0 + x1) // 2, y, mid)

    if compact and kind in ("rings", "flower", "ghost", "stamp"):
        c.put(x0, y, shadow)


def _boot_band(c, key):
    """靴踝一圈：y27 主行（整圈可见）+ y26 上沿（遮罩只露 x3..8）。"""
    line, mid = ROLES[key]["line"], ROLES[key]["mid"]
    shadow, spark = ROLES[key]["shadow"], ROLES[key]["spark"]
    kind = A.SETS[key]["motif"]
    x0, x1 = 0, 15

    if kind == "rings":
        c.line(x0, BOOT_MAIN_Y, x1, BOOT_MAIN_Y, line)
        c.line(3, BOOT_ACCENT_Y, 8, BOOT_ACCENT_Y, shadow)
        for x in range(3, x1 + 1, 4):
            c.put(x, BOOT_MAIN_Y, spark)
    elif kind == "crack":
        c.dashed(x0, BOOT_MAIN_Y, x1, BOOT_MAIN_Y, line, on=2, off=1)
        c.dashed(3, BOOT_ACCENT_Y, 8, BOOT_ACCENT_Y, shadow, on=1, off=2)
    elif kind == "flower":
        c.dashed(x0, BOOT_MAIN_Y, x1, BOOT_MAIN_Y, line, on=2, off=1)
        for x in (3, 4, 7, 8):
            c.put(x, BOOT_ACCENT_Y, mid)
        c.put(x0, BOOT_MAIN_Y, shadow)
        c.put(x1, BOOT_MAIN_Y, shadow)
    elif kind == "ghost":
        c.dashed(x0, BOOT_MAIN_Y, x1 - 1, BOOT_MAIN_Y, line, on=3, off=2)
        c.dashed(3, BOOT_ACCENT_Y, 8, BOOT_ACCENT_Y, shadow, on=3, off=2)
        c.put(3, BOOT_ACCENT_Y, mid)
    elif kind == "twin":
        midx = 7
        c.line(x0, BOOT_MAIN_Y, midx, BOOT_MAIN_Y, spark)
        c.line(midx + 1, BOOT_MAIN_Y, x1, BOOT_MAIN_Y, shadow)
        c.line(3, BOOT_ACCENT_Y, midx, BOOT_ACCENT_Y, shadow)
        c.line(midx + 1, BOOT_ACCENT_Y, 8, BOOT_ACCENT_Y, spark)
    elif kind == "stamp":
        for x in range(x0, x1 + 1, 3):
            c.line(x, BOOT_MAIN_Y, min(x + 1, x1), BOOT_MAIN_Y, line)
        c.put(x0, BOOT_MAIN_Y, shadow)
        c.put(x1, BOOT_MAIN_Y, shadow)
        c.put(3, BOOT_ACCENT_Y, mid)


# ---------------------------------------------------------------- 一层完整绘制
def paint_set(canvas, key, layer):
    """按规范 §4.3 的 7+3 个放置区落笔。"""
    if key not in A.SETS:
        raise KeyError(key)
    if layer == 1:
        _crest(canvas, key)
        _brow(canvas, key)
        _back(canvas, key)
        _badge(canvas, key, SHOULDER[0], SHOULDER[1], 1.6, compact=True)
        _band(canvas, key, 40, SHOULDER_RING_Y, 55)
        _badge(canvas, key, CHEST[0], CHEST[1], 2.6)
        _boot_band(canvas, key)
    elif layer == 2:
        _band(canvas, key, 0, THIGH_Y, 15)
        _badge(canvas, key, WAIST[0], WAIST[1], 2.4, compact=True)
        _band(canvas, key, 0, KNEE_Y, 15, compact=True)
    else:
        raise ValueError("layer must be 1 or 2")
    return canvas


# ---------------------------------------------------------------- 生成
def generate(verbose=True):
    os.makedirs(PATTERN_DIR, exist_ok=True)
    os.makedirs(PALETTE_DIR, exist_ok=True)
    written = []
    if verbose:
        print("target    %s" % os.path.relpath(PATTERN_DIR, PROJ).replace("\\", "/"))
        print("target    %s" % os.path.relpath(PALETTE_DIR, PROJ).replace("\\", "/"))
    for key in A.SET_ORDER:
        for layer, suffix in ((1, ""), (2, "_leggings")):
            c = A.TrimCanvas(layer)
            paint_set(c, key, layer)
            written.append(c.save(os.path.join(PATTERN_DIR, "%s%s.png" % (key, suffix))))
        written.append(A.save_palette(key, os.path.join(PALETTE_DIR, "%s.png" % key)))
    written.append(A.save_palette_key(os.path.join(PALETTE_DIR, "key.png")))
    if verbose:
        print("pattern   %2d 张 64×32 RGBA" % 12)
        print("palette   %2d 张 8×1 RGB（6 套 + key）" % 7)
    return written


# ---------------------------------------------------------------- 底甲与预览
def _load_base(layer):
    """读当前共用底甲；audit_base 不过或缺失直接失败，并返回 sha1。"""
    path = os.path.join(BASE_DIR, "netherite_layer_%d.png" % layer)
    if not os.path.exists(path):
        raise FileNotFoundError("底甲缺失：%s；请先运行 python -I src/tools/art/gen_netherite_base.py" % path)
    audit = A.audit_base(path, layer)
    if not audit["ok"]:
        raise ValueError("底甲 audit 未过：%r" % (audit.get("errors"),))
    with open(path, "rb") as fh:
        raw = fh.read()
    return Image.open(io.BytesIO(raw)).convert("RGBA"), hashlib.sha1(raw).hexdigest()


def _compose(base, trim, key):
    """64×32 纹饰按 1 纹素 = 2×2 底甲纹素放大后叠加（规范 §2.2）。"""
    colored = A.colorize_trim(trim, key).resize((128, 64), Image.NEAREST)
    out = base.copy()
    out.alpha_composite(colored)
    return out


def _coverage(im):
    px = im.load()
    return sum(1 for y in range(im.height) for x in range(im.width)
               if px[x, y][3]) / float(im.width * im.height)


def _panel(img, scale=SCALE, border=(64, 78, 92, 255)):
    big = img.resize((img.width * scale, img.height * scale), Image.NEAREST)
    bg = A._checker(big.width, big.height, 8, (30, 35, 42, 255), (37, 43, 51, 255))
    bg.alpha_composite(big)
    d = ImageDraw.Draw(bg)
    d.rectangle([0, 0, bg.width - 1, bg.height - 1], outline=border, width=1)
    return bg


def build_preview(out_path=PREVIEW, verbose=True):
    base1, sha1 = _load_base(1)
    base2, sha2 = _load_base(2)
    stamp = time.strftime("%Y-%m-%d %H:%M:%S")

    title_font = A._font(24, bold=True)
    sub_font = A._font(14)
    card_title = A._font(19, bold=True)
    label_font = A._font(12)
    small_font = A._font(11)

    W, H = _preview_size()
    out = Image.new("RGBA", (W, H), (22, 26, 32, 255))
    d = ImageDraw.Draw(out)

    d.text((MARGIN, 16), "镜中倒影 · 六套盔甲纹饰 × 共用底甲合成（4×）",
           font=title_font, fill=(240, 247, 252, 255))
    d.text((MARGIN, 46),
           "pattern 64×32 RGBA · 只用 trim_palette 的 8 个灰度值 · 1px 细线 · "
           "底甲 128×64 共用 · 纹饰 1 纹素 = 底甲 2×2（§2.2）",
           font=sub_font, fill=(150, 168, 184, 255))

    for i, key in enumerate(A.SET_ORDER):
        t1 = Image.open(os.path.join(PATTERN_DIR, "%s.png" % key)).convert("RGBA")
        t2 = Image.open(os.path.join(PATTERN_DIR, "%s_leggings.png" % key)).convert("RGBA")
        c1 = _compose(base1, t1, key)
        c2 = _compose(base2, t2, key)
        cx, cy = _card_origin(i)

        d.rectangle([cx, cy, cx + CARD_W - 1, cy + CARD_H - 1],
                    fill=(33, 38, 46, 255), outline=(60, 72, 86, 255), width=1)
        d.text((cx + 12, cy + 9), SET_LABEL[key], font=card_title,
               fill=(238, 246, 252, 255))
        d.text((cx + 12, cy + 33),
               "%s · L1 %.2f%% / L2 %.2f%%"
               % (key, _coverage(t1) * 100, _coverage(t2) * 100),
               font=small_font, fill=(146, 166, 184, 255))

        y = cy + 58
        out.alpha_composite(_panel(c1), (cx, y))
        d.text((cx + 8, y + PANEL_H + 3),
               "layer_1 · 盔 / 甲 / 臂 / 靴 · 64×32 → 128×64", font=label_font,
               fill=(196, 212, 226, 255))
        y += PANEL_H + 20 + 14
        out.alpha_composite(_panel(c2), (cx, y))
        d.text((cx + 8, y + PANEL_H + 3),
               "leggings · 腿 / 腰 · 64×32 → 128×64", font=label_font,
               fill=(196, 212, 226, 255))

        py = cy + CARD_H - 52
        for j, col in enumerate(A.palette_colors(key)):
            x = cx + 12 + j * 22
            d.rectangle([x, py, x + 20, py + 20], fill=col + (255,),
                        outline=(12, 14, 18, 255), width=1)
        d.text((cx + 12 + 8 * 22 + 6, py + 1), "palette 0 深 → 7 浅",
               font=small_font, fill=(170, 188, 204, 255))
        r = ROLES[key]
        d.text((cx + 12, py + 24),
               "灰度分工 line %d · mid %d · shadow %d · spark %d"
               % (r["line"], r["mid"], r["shadow"], r["spark"]), font=small_font,
               fill=(146, 166, 184, 255))

    d.text((MARGIN, H - 17),
           "底甲 sha1 L1 %s…  L2 %s…  ·  生成 %s  ·  面板逐像素 = 当前底甲 + 落盘 trim"
           % (sha1[:12], sha2[:12], stamp),
           font=small_font, fill=(128, 146, 162, 255))

    meta = PngInfo()
    meta.add_text("plm_base_l1_sha1", sha1)
    meta.add_text("plm_base_l2_sha1", sha2)
    meta.add_text("plm_build_time", stamp)
    meta.add_text("plm_generator", "src/tools/art/gen_trims.py")
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    out.save(out_path, pnginfo=meta)
    if verbose:
        print("preview   %s  %dx%d  base L1 %s… L2 %s…"
              % (os.path.relpath(out_path, PROJ).replace("\\", "/"),
                 out.width, out.height, sha1[:12], sha2[:12]))
    return out_path, sha1, sha2


# ---------------------------------------------------------------- 自检
def _trim_metrics(path, layer):
    raw = Image.open(path)
    mode = raw.mode
    im = raw.convert("RGBA")
    px = im.load()
    mask = A.netherite_mask(layer).load()
    visible = outside = bad_gray = bad_alpha = 0
    grays = set()
    for yy in range(im.height):
        for xx in range(im.width):
            r, g, b, a = px[xx, yy]
            if a not in (0, 255):
                bad_alpha += 1
                continue
            if a == 0:
                continue
            visible += 1
            grays.add(r)
            if r not in A.GRAY_SET or not (r == g == b):
                bad_gray += 1
            if mask[xx, yy] == 0:
                outside += 1
    return {
        "size": im.size, "mode": mode, "visible": visible,
        "coverage": visible / float(im.width * im.height),
        "grays": sorted(grays), "outside": outside,
        "bad_gray": bad_gray, "bad_alpha": bad_alpha,
    }


def _palette_metrics(path):
    im = Image.open(path).convert("RGB")
    cols = [im.getpixel((j, 0)) for j in range(im.width)]
    lums = [A.luminance(c) for c in cols]
    mono = all(lums[j] <= lums[j + 1] for j in range(len(lums) - 1))
    return {
        "size": im.size, "colors": cols, "luminance": lums,
        "unique": len(set(cols)), "mono": mono,
    }


def manifest_errors(path=MANIFEST):
    """manifest 的 coverage/gray_values/gray_roles/placement 必须等于落盘 PNG。"""
    errs = []
    if not os.path.exists(path):
        return ["manifest 缺失：%s" % path]
    with open(path, encoding="utf-8") as fh:
        m = json.load(fh)
    for key in A.SET_ORDER:
        s = m.get("sets", {}).get(key)
        if not s:
            errs.append("%s manifest 缺 set" % key)
            continue
        grays = set()
        for layer, tag in ((1, "layer_1"), (2, "leggings")):
            p = os.path.join(PATTERN_DIR, "%s%s.png" % (key, "_leggings" if layer == 2 else ""))
            if not os.path.exists(p):
                errs.append("%s 缺 PNG" % p)
                continue
            actual = _trim_metrics(p, layer)
            grays |= set(actual["grays"])
            want = s.get("coverage", {}).get(tag)
            if want is None or abs(actual["coverage"] - want) > 0.0002:
                errs.append("%s %s coverage %r != 实测 %.5f"
                            % (key, tag, want, actual["coverage"]))
        if sorted(s.get("gray_values", [])) != sorted(grays):
            errs.append("%s gray_values %r != 实测 %r"
                        % (key, s.get("gray_values"), sorted(grays)))
        for role, gray in ROLES[key].items():
            got = s.get("gray_roles", {}).get(role, {}).get("gray")
            if got != gray:
                errs.append("%s gray_role.%s %r != %d" % (key, role, got, gray))
    p2 = m.get("placement", {}).get("layer_2", {})
    if list(p2.get("waist_front", {}).get("anchor", [])) != [WAIST[0], WAIST[1]]:
        errs.append("manifest waist_front.anchor %r != %r"
                    % (p2.get("waist_front", {}).get("anchor"), list(WAIST)))
    if list(p2.get("knee_band", {}).get("box", [])) != [0, KNEE_Y, 16, 1]:
        errs.append("manifest knee_band.box %r != [0,%d,16,1]"
                    % (p2.get("knee_band", {}).get("box"), KNEE_Y))
    return errs


def write_manifest(path=MANIFEST, verbose=True):
    """从落盘 PNG 重算 manifest；保留 atlas/base/lang 等其余字段。"""
    if not os.path.exists(path):
        raise FileNotFoundError("manifest 不存在：%s" % path)
    with open(path, encoding="utf-8") as fh:
        m = json.load(fh)
    m["generated_by"] = "src/tools/art/gen_trims.py（从落盘 PNG 重算）"
    m["single_source_of_truth"] = True
    for key in A.SET_ORDER:
        s = m["sets"][key]
        t1 = _trim_metrics(os.path.join(PATTERN_DIR, "%s.png" % key), 1)
        t2 = _trim_metrics(os.path.join(PATTERN_DIR, "%s_leggings.png" % key), 2)
        grays = sorted(set(t1["grays"]) | set(t2["grays"]))
        s["coverage"] = {"layer_1": round(t1["coverage"], 4),
                         "leggings": round(t2["coverage"], 4)}
        s["gray_values"] = grays
        s["gray_roles"] = {role: {"gray": gray, "role_cn": ROLE_CN[role]}
                           for role, gray in ROLES[key].items()}
        s["motif_recipe"] = RECIPES[key]
        pm = _palette_metrics(os.path.join(PALETTE_DIR, "%s.png" % key))
        s["palette"]["colors"] = ["#%02X%02X%02X" % c for c in pm["colors"]]
        s["palette"]["luminance"] = [round(v, 1) for v in pm["luminance"]]
        if key == "twin":
            s["accent"] = ["#E8C060", "#4A78C0"]
    p1 = m["placement"]["layer_1"]
    p1["shoulder_ring"]["box"] = [40, 22, 16, 2]
    p2 = m["placement"]["layer_2"]
    p2["thigh_band"]["box"] = [0, 23, 16, 2]
    p2["waist_front"] = {
        "box": [20, 27, 8, 5],
        "anchor": [WAIST[0], WAIST[1]],
        "r": 2.4,
        "sentry": "vanilla netherite_layer_2 可见前腰 y=27..31；规范原锚点 y=25 在遮罩外，已修正",
    }
    p2["knee_band"] = {
        "box": [0, KNEE_Y, 16, 1],
        "anchor": [7.5, float(KNEE_Y)],
        "r": None,
        "sentry": "腿面 y=20..28 的下段；规范原 box y=29 在遮罩外，已修正",
    }
    checks = m.setdefault("checks", [])
    for cmd in ("python -I src/tools/art/gen_trims.py",
                "python -I src/tools/art/gen_trims.py --check",
                "python -I src/tools/art/trim_gen_sample.py --check"):
        if cmd not in checks:
            checks.append(cmd)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(m, fh, ensure_ascii=False, indent=2)
        fh.write("\n")
    if verbose:
        print("manifest  %s  coverage/gray_roles/placement 从落盘 PNG 重算"
              % os.path.relpath(path, PROJ).replace("\\", "/"))
    return path


def audit(verbose=True):
    errors, rows = [], []
    for key in A.SET_ORDER:
        for layer, suffix, tag in ((1, "", "layer_1"), (2, "_leggings", "leggings")):
            path = os.path.join(PATTERN_DIR, "%s%s.png" % (key, suffix))
            if not os.path.exists(path):
                errors.append("缺文件 %s" % path)
                continue
            m = _trim_metrics(path, layer)
            official = A.audit_trim(path, layer)
            c = A.TrimCanvas(layer)
            paint_set(c, key, layer)
            same_painter = c.to_image().tobytes() == Image.open(path).convert("RGBA").tobytes()
            lo = A.MIN_TRIM_COVERAGE["leggings" if layer == 2 else "layer_1"]
            hi = A.MAX_TRIM_COVERAGE["leggings" if layer == 2 else "layer_1"]
            ok = (m["size"] == (64, 32) and m["mode"] == "RGBA"
                  and m["visible"] > 0 and lo <= m["coverage"] <= hi
                  and m["outside"] == 0 and m["bad_gray"] == 0
                  and m["bad_alpha"] == 0
                  and set(m["grays"]) <= set(A.GRAYS)
                  and official["ok"] and same_painter)
            if not ok:
                errors.append("%s/%s 未过：%r official=%r painter=%s"
                              % (key, tag, m, official.get("errors"), same_painter))
            rows.append((key, tag, m, ok))

    pal_rows = []
    for key in A.SET_ORDER:
        path = os.path.join(PALETTE_DIR, "%s.png" % key)
        if not os.path.exists(path):
            errors.append("缺文件 %s" % path)
            continue
        p = _palette_metrics(path)
        official = A.audit_palette(path)
        want = [A.hx(s)[:3] for s in A.SETS[key]["stops"]]
        ok = (p["size"] == (8, 1) and p["unique"] == 8 and p["mono"]
              and p["colors"] == want and official["ok"])
        if not ok:
            errors.append("%s palette 未过：%r official=%r"
                          % (key, p, official.get("errors")))
        pal_rows.append((key, p, ok))

    key_path = os.path.join(PALETTE_DIR, "key.png")
    key_ok = False
    key_vals = []
    if os.path.exists(key_path):
        key_official = A.audit_palette(key_path)
        im = Image.open(key_path).convert("RGB")
        key_vals = [im.getpixel((j, 0)) for j in range(im.width)]
        key_ok = (im.size == (8, 1)
                  and [c[0] for c in key_vals] == list(A.GRAYS)
                  and all(c[0] == c[1] == c[2] for c in key_vals)
                  and key_official["ok"])
    if not key_ok:
        errors.append("key.png 未过：%r" % (key_vals,))

    prev_ok = False
    prev_size = None
    panel_bad = []
    try:
        b1, sha1 = _load_base(1)
        b2, sha2 = _load_base(2)
    except Exception as exc:  # noqa: BLE001
        errors.append("底甲不可用：%r" % (exc,))
    else:
        if os.path.exists(PREVIEW):
            im = Image.open(PREVIEW)
            prev_size = im.size
            prev_ok = (im.mode == "RGBA" and im.size == _preview_size()
                       and im.info.get("plm_base_l1_sha1") == sha1
                       and im.info.get("plm_base_l2_sha1") == sha2)
            if not prev_ok:
                errors.append("预览尺寸/模式/底甲 sha1 不符：size=%r l1=%r l2=%r"
                              % (im.size, im.info.get("plm_base_l1_sha1"),
                                 im.info.get("plm_base_l2_sha1")))
            for i, key in enumerate(A.SET_ORDER):
                for layer in (1, 2):
                    suffix = "_leggings" if layer == 2 else ""
                    t = Image.open(os.path.join(PATTERN_DIR, "%s%s.png" % (key, suffix))).convert("RGBA")
                    exp = _panel(_compose(b1 if layer == 1 else b2, t, key))
                    cx, py = _panel_origin(i, layer)
                    act = im.crop((cx, py, cx + PANEL_W, py + PANEL_H)).convert("RGBA")
                    if exp.tobytes() != act.tobytes():
                        panel_bad.append("%s L%d" % (key, layer))
            if panel_bad:
                errors.append("预览面板与当前底甲+trim 不一致：%s" % ", ".join(panel_bad))
                prev_ok = False
        else:
            errors.append("预览缺失")

    merrs = manifest_errors()
    errors.extend(merrs)

    if verbose:
        print("")
        print("%-5s %-9s %-7s %6s %8s  %s" %
              ("set", "layer", "size", "pixels", "cover", "grays"))
        for key, tag, m, ok in rows:
            print("%-5s %-9s %-7s %6d %7.2f%%  %-16s %s"
                  % (key, tag, "%dx%d" % m["size"], m["visible"],
                     m["coverage"] * 100, ",".join(str(g) for g in m["grays"]),
                     "PASS" if ok else "FAIL"))
        print("")
        for key, p, ok in pal_rows:
            hexes = " ".join("#%02X%02X%02X" % c for c in p["colors"])
            print("palette %-5s %dx%d  %s  L %.1f→%.1f  %s"
                  % (key, p["size"][0], p["size"][1], hexes,
                     p["luminance"][0], p["luminance"][-1],
                     "PASS" if ok else "FAIL"))
        print("key     8x1  %s  %s"
              % (" ".join(str(c[0]) for c in key_vals),
                 "PASS" if key_ok else "FAIL"))
        print("preview %s  %s  panels=%s"
              % ("%dx%d" % prev_size if prev_size else "-",
                 "PASS" if prev_ok else "FAIL",
                 "12/12" if not panel_bad else "BAD:" + ",".join(panel_bad)))
        print("manifest %s  %s" % (os.path.relpath(MANIFEST, PROJ).replace("\\", "/"),
                                   "PASS" if not merrs else "FAIL"))
        for msg in merrs:
            print("  ! " + msg)
        print("result  %s" % ("PASS" if not errors else "FAIL"))
        for msg in errors:
            print("  ! " + msg)
    return errors, rows, pal_rows


def _print_offsets():
    print("note    layer_2 waist_front 规范 y=25 在 netherite 遮罩外，已落到 y=29.0（可见腰带 y=27..31）")
    print("note    layer_2 knee_band 规范 y=29 在腿面遮罩外，已落到 y=26（腿面内）")


# ---------------------------------------------------------------- CLI
def main(argv=None):
    ap = argparse.ArgumentParser(description="镜中倒影六套盔甲纹饰生成器")
    ap.add_argument("--check", action="store_true", help="只读复检，不写文件")
    args = ap.parse_args(argv)

    if not args.check:
        generate()
        build_preview()
        write_manifest()
        _print_offsets()
    else:
        print("check    只读复检 %s" % os.path.relpath(PACK, PROJ).replace("\\", "/"))
        _print_offsets()
    errors, _rows, _pals = audit()
    return 0 if not errors else 1


if __name__ == "__main__":
    sys.exit(main())
