# -*- coding: utf-8 -*-
"""
gen_materials —— 《梦回盘灵：镜中倒影》材料组 33 张贴图生成器

单一事实源：src/tools/art/manifest.json 中 kind == 'material' 的 33 条。
共用画具：src/tools/art/mirror_art.py（Canvas / MIRROR / ELEMENT_COLORS /
          SET_STYLE / seal_stamp / annulus_sector_mask / bezier /
          contact_sheet / audit_icon_file）。

产物：
  33 × PNG  -> <resourcepack_root>/<texture>
               即 src/resourcepack/assets/panling/textures/item/mirror_*.png
  接触表     -> out/art/sheet_materials.png（4×、带标签；底部附 16×16 实际尺寸复核行）

约束（《镜中倒影_美术规范_v1.0.md》）：
  * 64×64 RGBA、透明底、二值 alpha；
  * 主体画在 2..61，外描边 #14181D 占 1..62，最外圈 0/63 恒透明；
  * 每图 ≤20 色、硬边、光源左上、每图 1–2 条 1px 斜向镜面反光；
  * 五行元素色直接取 mirror_art.ELEMENT_COLORS（base/light/dark），不另造色；
  * 六套镜缘直接取 mirror_art.SET_STYLE 的 accent/accent_dark。

运行：
  python -I src/tools/art/gen_materials.py
"""
from __future__ import annotations

import hashlib
import json
import math
import os
import random
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import mirror_art as art  # noqa: E402
from PIL import Image, ImageDraw  # noqa: E402

PROJ = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
MANIFEST_PATH = os.path.join(HERE, 'manifest.json')
SHEET_PATH = os.path.join(PROJ, 'out', 'art', 'sheet_materials.png')

M = art.MIRROR          # 0 高光 / 1 亮面 / 2 中间 / 3 暗面 / 4 最暗
OUTLINE = art.OUTLINE

# 模具体色（规范 §8.4）
MOLD_BODY = art.MOLD_BODY
MOLD_RECESS = art.MOLD_RECESS

# 影尘 / 砺镜砂 / 定影符（规范 §8.6 / §8.7 指定色）
DUST_BASE, DUST_DARK, DUST_LIGHT = art.hx('#6B5A7D'), art.hx('#4A3D57'), art.hx('#9A87AD')
DUST_GRAINS = (art.hx('#8A76A0'), art.hx('#C9B8DC'), art.hx('#4A3D57'))
SAND_BASE, SAND_DARK, SAND_LIGHT = art.hx('#D8D5CC'), art.hx('#A8A49A'), art.hx('#F2F0E8')
SAND_GRAINS = (art.hx('#BDB9AE'), art.hx('#EDEAE0'), art.hx('#8F8B80'))
PAPER_EDGE_L, PAPER_EDGE_D = art.hx('#C9BFA6'), art.hx('#A89E86')
HOLE = art.hx('#6B6152')
SEAL_RED, SEAL_REV = art.hx('#C8483C'), art.hx('#6B3FA0')
INK = art.hx('#2B2B2B')


# ---------------------------------------------------------------- 公用

def _finish(c, shade=None, highlight=None, shade_color=None, highlight_color=None):
    """填色 → 右下阴影 → 左上高光 → 外描边 → 色数压限（规范 §4.1 顺序）。"""
    if shade:
        c.edge_shade(shade, shade_color or M[3])
    if highlight:
        c.edge_highlight(highlight, highlight_color or M[0])
    c.outline()
    c.enforce_color_limit(art.MAX_COLORS)
    return c


def _scale_pts(pts, k, cx=32.0, cy=32.0):
    return [(cx + (x - cx) * k, cy + (y - cy) * k) for x, y in pts]


def _star(c, x, y, core, arm):
    """4 臂十字星（5px），用于影尘。"""
    c.put(x, y, core)
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        c.put(x + dx, y + dy, arm)


# ---------------------------------------------------------------- 镜片 ×5

# 规范 §8.3：主碎镜 5 点外三角；五元素共用同一外形，只换色芯
SHARD_OUTER = [(34, 6), (55, 37), (40, 46), (18, 52), (24, 30)]
SHARD_CORE = [(32, 12), (52, 37), (20, 47)]


def draw_shard(element):
    c = art.Canvas()
    base, light, dark = art.element_palette(element)

    outer = c.poly(SHARD_OUTER, M[2])
    # 左上受光面（镜银亮面）
    c.poly([SHARD_OUTER[0], SHARD_OUTER[4], SHARD_OUTER[2]], M[1])
    # 元素色芯（≥12% 画布面积，16×16 仍能分出五行）
    c.poly(SHARD_CORE, base)
    c.poly([(32, 12), (41, 32), (27, 40)], light)
    c.line(SHARD_CORE[1][0], SHARD_CORE[1][1],
           SHARD_CORE[2][0], SHARD_CORE[2][1], dark, 1)
    # 2 条断口线（#5C7180）
    c.line(34, 7, 29, 19, M[3], 1)
    c.line(41, 45, 44, 40, M[3], 1)
    # 1 条镜面反光（落在左侧镜银棱上）
    c.glint_line(33, 9, 29, 20, M[0], mask=outer)
    # 右下小碎镜，与主三角保持 ≥2px 间距
    chip = c.poly([(49, 51), (55, 54), (48, 56)], M[1])
    c.line(50, 52, 53, 54, base, 1)
    _finish(c, shade=outer | chip, highlight=outer)
    return c


# ---------------------------------------------------------------- 镜心 ×5

# 规范 §8.3：金/木/土六边，水/火菱形；内层元素色 + 核心亮色 + 刻面线
HEART_HEX = [(32, 7), (52, 19), (52, 45), (32, 57), (12, 45), (12, 19)]
HEART_DIAMOND = [(32, 5), (57, 32), (32, 59), (7, 32)]


def draw_heart(element):
    c = art.Canvas()
    base, light, dark = art.element_palette(element)
    diamond = element in ('water', 'fire')
    outer_pts = HEART_DIAMOND if diamond else HEART_HEX
    k_in, k_core = (0.65, 0.30) if diamond else (0.62, 0.30)

    outer = c.poly(outer_pts, M[2])
    # 左上受光面
    c.poly([outer_pts[0], outer_pts[-1], (32, 32)], M[1])
    inner_pts = _scale_pts(outer_pts, k_in)
    c.poly(inner_pts, base)
    # 刻面线：中心连到各外顶点（1px #5C7180，规范 §8.3）
    for p in outer_pts:
        c.line(32, 32, p[0], p[1], M[3], 1)
    c.poly(_scale_pts(outer_pts, k_core), light)
    # 元素暗边：内层下沿
    low = sorted(inner_pts, key=lambda p: p[1])[-2:]
    low.sort(key=lambda p: p[0])
    c.line(low[0][0], low[0][1], 32, max(p[1] for p in inner_pts), dark, 1)
    c.line(32, max(p[1] for p in inner_pts), low[1][0], low[1][1], dark, 1)
    # 中轴 1px 白 + 左上反光
    c.line(32, int(min(p[1] for p in inner_pts)) - 6, 32, 31, M[0], 1)
    c.glint_line(23, 27, 29, 17, M[0], mask=outer)
    _finish(c, shade=outer, highlight=outer)
    return c


# ---------------------------------------------------------------- 镜胚 ×10

def _mold_block(c, armor=False):
    """深灰模具块 + 内凹槽；armor=True 时外框多一处对位槽（武器胚/防具胚区分）。"""
    block = c.poly([(14, 10), (50, 10), (54, 14), (54, 48), (50, 52), (14, 52),
                    (10, 48), (10, 14)], MOLD_BODY)
    c.line(12, 12, 52, 12, M[3], 1)          # 上沿 1px #5C7180
    c.line(12, 12, 12, 50, M[3], 1)          # 左沿 1px #5C7180
    c.edge_shade(block, M[4])                # 右下压暗
    recess = c.rect(16, 16, 48, 46, MOLD_RECESS)
    c.rect(18, 10, 22, 13, MOLD_RECESS)      # 顶部 2 个缺口
    c.rect(42, 10, 46, 13, MOLD_RECESS)
    c.glint_line(11, 22, 14, 19, M[0])       # 块体左上棱反光（避开对位槽）
    if armor:
        # 防具胚的外框差异：左侧 3×18px 对位槽 + 顶心缺口
        c.rect(11, 24, 13, 41, MOLD_RECESS)
        c.line(14, 24, 14, 41, M[3], 1)
        c.rect(30, 10, 34, 13, MOLD_RECESS)
    c.line(16, 16, 48, 16, M[3], 1)          # 凹槽上/左内壁
    c.line(16, 16, 16, 46, M[3], 1)
    return block, recess


# 内剪影按规范 §8.4 的器形表逐项绘制（圆格/月牙/贝塞尔弧/横臂/两小球/方板/面甲缺口等），
# 线宽 3–4px，颜色镜银 #9DB2BE（M[2]），左上 1px 高光 M[1]。
ARMOR_MOLDS = ('helmet', 'chestplate', 'leggings', 'boots')


def _mold_sword(c):
    """§8.4：斜线 4px + 圆格 r≈3 + 短柄。"""
    m = c.line(24, 42, 44, 22, M[2], 5)      # 斜刃（约 4px 粗）
    m |= c.circle(26, 41, 4.8, M[2])         # 圆格（r≈3-5，缩到 16×16 仍可见）
    m |= c.line(20, 44, 25, 41, M[2], 4)     # 短柄
    m |= c.circle(20, 43, 1.8, M[1])         # 剑首
    c.edge_highlight(m, M[1])
    return m


def _mold_axe(c):
    """§8.4：斜柄 3px + 小月牙。"""
    m = c.line(21, 44, 33, 31, M[2], 4)      # 斜柄
    m |= c.paint_mask(art.disc_mask(40, 25, 9.0) - art.disc_mask(47, 18, 8.0), M[2])
    c.edge_highlight(m, M[1])
    return m


def _mold_bow(c):
    """§8.4：贝塞尔弧 2px + 直弦 1px。"""
    curve = art.bezier((20, 45), (26, 23), (44, 19), 24)
    m = c.polyline(curve, M[2], 4)           # 贝塞尔弧
    c.line(20, 45, 44, 19, M[0], 1)          # 直弦 1px
    c.edge_highlight(m, M[1])
    return m


def _mold_crossbow(c):
    """§8.4：斜身 3px + 横臂 2px + 镜机圆。"""
    m = c.line(22, 44, 40, 26, M[2], 4)      # 斜身
    m |= c.line(25, 18, 45, 38, M[2], 4)     # 横臂（贯穿，靠前）
    m |= c.circle(30, 36, 3.2, M[2])         # 镜机圆
    m |= c.circle(25, 18, 2.0, M[1])         # 弓臂端头
    m |= c.circle(45, 38, 2.0, M[1])
    c.edge_highlight(m, M[1])
    return m


def _mold_furnace_twin(c):
    """§8.4：竖杖 3px + 横梁 2px + 两小球。"""
    m = c.line(32, 44, 32, 23, M[2], 4)      # 竖杖
    m |= c.line(23, 23, 41, 23, M[2], 4)     # 横梁
    m |= c.circle(22, 20, 3.6, M[2])         # 两小球
    m |= c.circle(42, 20, 3.6, M[2])
    c.edge_highlight(m, M[1])
    return m


def _mold_furnace_rub(c):
    """§8.4：竖杖 3px + 方板。"""
    m = c.line(32, 44, 32, 27, M[2], 4)      # 竖杖
    m |= c.rect(22, 16, 42, 28, M[2])        # 方板
    c.edge_highlight(m, M[1])
    return m


def _mold_helmet(c):
    """§8.4：半圆顶 + 面甲缺口。"""
    pts = [(32 + 14 * math.cos(math.radians(a)), 30 + 12 * math.sin(math.radians(a)))
           for a in range(180, 361, 10)]
    pts += [(46, 38), (18, 38)]
    m = c.poly(pts, M[2])                    # 半圆顶 + 下沿
    c.rect(26, 24, 38, 36, MOLD_RECESS)      # 面甲缺口
    c.edge_highlight(m, M[1])
    return m


def _mold_chestplate(c):
    """§8.4：躯干五边形 + 领口缺口。"""
    m = c.poly([(24, 18), (40, 18), (44, 25), (42, 40), (32, 43), (22, 40), (20, 25)], M[2])
    m |= c.circle(20, 24, 2.6, M[2])         # 肩甲
    m |= c.circle(44, 24, 2.6, M[2])
    c.rect(28, 18, 36, 21, MOLD_RECESS)      # 领口缺口
    c.edge_highlight(m, M[1])
    return m


def _mold_leggings(c):
    """§8.4：腰带 + 双腿。"""
    m = c.rect(20, 18, 44, 23, M[2])         # 腰带
    m |= c.rect(21, 23, 29, 44, M[2])        # 左腿
    m |= c.rect(35, 23, 43, 44, M[2])        # 右腿
    c.edge_highlight(m, M[1])
    return m


def _mold_boots(c):
    """§8.4：双靴筒 + 脚面。"""
    m = c.rect(20, 22, 27, 34, M[2])         # 左靴筒
    m |= c.rect(37, 22, 44, 34, M[2])        # 右靴筒
    m |= c.poly([(20, 33), (27, 33), (31, 42), (17, 42)], M[2])   # 左脚面
    m |= c.poly([(37, 33), (44, 33), (47, 42), (33, 42)], M[2])   # 右脚面
    c.edge_highlight(m, M[1])
    return m


MOLD_DRAW = {
    'sword': _mold_sword,
    'axe': _mold_axe,
    'bow': _mold_bow,
    'crossbow': _mold_crossbow,
    'furnace_twin': _mold_furnace_twin,
    'furnace_rub': _mold_furnace_rub,
    'helmet': _mold_helmet,
    'chestplate': _mold_chestplate,
    'leggings': _mold_leggings,
    'boots': _mold_boots,
}


def draw_mold(variant):
    c = art.Canvas()
    block, recess = _mold_block(c, armor=variant in ARMOR_MOLDS)
    with c.clipped(recess):
        MOLD_DRAW[variant](c)
    _finish(c, shade=block, highlight=None)
    return c


# ---------------------------------------------------------------- 镜缘 ×6

def draw_edge(style):
    c = art.Canvas()
    accent0 = art.style_acc(style, 0)
    accent1 = art.style_acc(style, 1)
    dark = art.style_dark(style)

    ring = art.annulus_sector_mask(32, 36, 17, 27, 200, 340)
    c.paint_mask(ring, M[2])
    # 内圈 #CFE0E8
    c.paint_mask(art.annulus_sector_mask(32, 36, 17, 20.4, 200, 340), M[1])
    # 强调色嵌条 r≈22（1px 带宽）
    c.paint_mask(art.annulus_sector_mask(32, 36, 21.8, 23.2, 200, 340), accent0)
    # 4 条刻度（220/250/290/320）
    for a in (220, 250, 290, 320):
        rad = math.radians(a)
        c.line(32 + math.cos(rad) * 18, 36 + math.sin(rad) * 18,
               32 + math.cos(rad) * 26, 36 + math.sin(rad) * 26, M[4], 1)
    # 两端 3px 端头（强调暗色 + 亮点）
    for a in (200, 340):
        rad = math.radians(a)
        ex, ey = 32 + math.cos(rad) * 22, 36 + math.sin(rad) * 22
        c.circle(ex, ey, 3.2, dark)
        c.circle(ex, ey, 1.5, accent1)
    c.edge_highlight(ring, M[1])
    c.glint_line(14, 30, 26, 18, M[0], mask=ring)
    _finish(c, shade=ring)
    return c


# ---------------------------------------------------------------- 影尘 / 砺镜砂

def draw_dust():
    c = art.Canvas()
    mound = c.poly([(10, 50), (16, 38), (24, 32), (32, 34), (40, 30), (50, 36),
                    (54, 48), (50, 54), (14, 54)], DUST_BASE)
    c.edge_shade(mound, DUST_DARK)
    c.edge_highlight(mound, DUST_LIGHT)
    rnd = random.Random(1211)
    n = 0
    while n < 26:
        x, y = rnd.randint(12, 52), rnd.randint(31, 53)
        if (x, y) in mound:
            c.put(x, y, rnd.choice(DUST_GRAINS))
            n += 1
    # 4 个十字星：2 个在堆外上方，2 个落在堆上
    for x, y in ((18, 22), (45, 19), (27, 38), (43, 37)):
        _star(c, x, y, M[0], art.hx('#C9B8DC'))
    _finish(c, shade=None, highlight=None)
    return c


def draw_sand():
    c = art.Canvas()
    mound = c.poly([(10, 48), (18, 34), (28, 30), (38, 32), (48, 38), (54, 48),
                    (52, 54), (12, 54)], SAND_BASE)
    c.edge_shade(mound, SAND_DARK)
    c.edge_highlight(mound, SAND_LIGHT)
    rnd = random.Random(7)
    n = 0
    while n < 70:
        x, y = rnd.randint(12, 52), rnd.randint(31, 53)
        if (x, y) in mound:
            c.put(x, y, rnd.choice(SAND_GRAINS))
            n += 1
    # 3 个纯白亮点（规范 §8.6）
    for x, y in ((23, 40), (34, 36), (43, 43)):
        c.put(x, y, art.hx('#FFFFFF'))
    _finish(c, shade=None, highlight=None)
    return c


# ---------------------------------------------------------------- 定影符 ×4

def draw_seal(variant):
    c = art.Canvas()
    rev = variant == 'rev'
    paper = art.hx('#D8CFC0') if rev else art.hx('#E8DFC8')
    ink = art.hx('#6B3FA0') if rev else INK
    seal_col = SEAL_REV if rev else SEAL_RED

    # 纸符：顶部方角，底部 6 个撕裂三角到 y=43
    sheet = c.poly([(16, 10), (48, 10), (48, 38), (45, 43), (42, 38), (39, 43),
                    (36, 38), (33, 43), (30, 38), (27, 43), (24, 38), (21, 43),
                    (18, 38), (16, 38)], paper)
    c.line(16, 10, 48, 10, PAPER_EDGE_L, 1)
    c.line(16, 10, 16, 38, PAPER_EDGE_L, 1)
    c.line(48, 10, 48, 38, PAPER_EDGE_D, 1)
    # 3 列竖排符文（x=21/25/29，y=15..31）
    for x in (21, 25, 29):
        c.line(x, 15, x, 31, ink, 1)
        for y in (17, 21, 25, 29):
            c.line(x - 1, y, x + 1, y, ink, 1)
    # 印章方框 (33,25)-(45,36)
    if rev:
        # 反符：紫底纸字，印纹上下翻转（横画下移、竖画偏右）
        c.rect(33, 25, 45, 36, seal_col)
        for y in (30, 32, 34):
            c.line(36, y, 43, y, paper, 1)
        c.line(41, 27, 41, 35, paper, 1)
        c.line(34, 35, 44, 26, PAPER_EDGE_L, 1)      # 对角折线
    else:
        # 3px 朱红外框 + 纸色内芯：1px 框在 64→16 最近邻会整块消失，
        # 实测 1px 框 16×16 红色像素 0，3px 框 7 个（§8.7 要求红方印可读）。
        c.rect(33, 25, 45, 36, seal_col)
        c.rect(36, 28, 42, 33, paper)
        for i in range(int(variant)):
            c.line(37, 29 + i * 2, 41, 29 + i * 2, ink, 1)
        c.line(39, 29, 39, 33, ink, 1)
    # 顶部挂绳孔
    c.circle(32, 13, 1.4, HOLE)
    _finish(c, shade=sheet, shade_color=PAPER_EDGE_D)
    return c


# ---------------------------------------------------------------- 倒影核

def draw_core():
    c = art.Canvas()
    orb = c.circle(32, 32, 23, M[2])
    c.circle(31, 31, 22, M[1])
    purple, purple_l = art.hx('#6B4A9E'), art.hx('#A46BE8')
    turns, steps = 2.7, 340
    # 螺距按 t^3 渐变：内圈极紧、外圈拉得很开（r 仍从 3 到 18.5，2.7 圈）。
    # 均匀螺距在 64→16 最近邻下会退化成同心圆/靶心；外圈最后 55% 参数段
    # 加粗到 4px，16×16 仍能读出「圆球 + 螺旋」的开口旋转（半径分布 1..5px）。
    pts = []
    for i in range(steps + 1):
        t = i / float(steps)
        a = t * turns * 2 * math.pi
        r = 3 + 15.5 * (t ** 3.0)
        pts.append((32 + math.cos(a) * r, 32 + math.sin(a) * r))
    c.polyline(pts, purple, 1)
    for off in (1.0, 2.0, 3.0):
        seg = []
        for i in range(int(steps * 0.45), steps + 1):
            t = i / float(steps)
            a = t * turns * 2 * math.pi
            rr = 3 + 15.5 * (t ** 3.0) + off
            seg.append((32 + math.cos(a) * rr, 32 + math.sin(a) * rr))
        c.polyline(seg, purple, 1)
    for i in range(0, steps + 1, 42):
        c.put(int(round(pts[i][0])), int(round(pts[i][1])), purple_l)
    c.circle(32, 32, 3.4, art.hx('#2C1B45'))
    c.circle(32, 32, 1.8, M[0])
    c.glint_line(18, 22, 26, 14, M[0], mask=orb)
    _finish(c, shade=orb, highlight=orb)
    return c


# ---------------------------------------------------------------- 分发

def draw_material(entry):
    kind = entry['material']
    variant = entry.get('variant')
    if kind == 'shard':
        return draw_shard(variant)
    if kind == 'heart':
        return draw_heart(variant)
    if kind == 'mold':
        return draw_mold(variant)
    if kind == 'edge':
        return draw_edge(art.SET_STYLE[variant])
    if kind == 'dust':
        return draw_dust()
    if kind == 'sand':
        return draw_sand()
    if kind == 'seal':
        return draw_seal(variant)
    if kind == 'core':
        return draw_core()
    raise ValueError('unknown material kind: %r' % kind)


# ---------------------------------------------------------------- 自检

EXPECTED_CMD = {
    'shard': [300, 305, 310, 315, 320],
    'heart': [340, 345, 350, 355, 360],
    'mold': [370, 371, 372, 373, 374, 375, 376, 377, 378, 379],
    'edge': [380, 381, 382, 383, 384, 385],
    'dust': [390],
    'sand': [391],
    'seal': [400, 401, 402, 403],
    'core': [410],
}
EXPECTED_COUNT = {'shard': 5, 'heart': 5, 'mold': 10, 'edge': 6,
                  'dust': 1, 'sand': 1, 'seal': 4, 'core': 1}
ELEMENT_KINDS = ('shard', 'heart')


def _sha256(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(65536), b''):
            h.update(chunk)
    return h.hexdigest()


def _pixel_set(im):
    return set(im.getdata())


def check_entry(entry, path):
    """单张落盘后的硬检查。"""
    errs = []
    im = Image.open(path)
    if im.size != (64, 64):
        errs.append('尺寸 %r' % (im.size,))
    if im.mode != 'RGBA':
        errs.append('模式 %s' % im.mode)
    im = im.convert('RGBA')
    w, h = im.size
    px = im.load()

    alphas = set()
    colors = set()
    opaque = []
    for y in range(h):
        for x in range(w):
            c = px[x, y]
            alphas.add(c[3])
            if c[3] > 0:
                colors.add(c)
                opaque.append((x, y))
    if not alphas <= {0, 255}:
        errs.append('alpha 非二值 %r' % sorted(alphas))
    if not opaque:
        errs.append('空图')
        return {'errors': errs}

    bbox = im.getbbox()                       # alpha bbox，right/bottom 为开区间
    if bbox[0] < 1 or bbox[1] < 1 or bbox[2] > 63 or bbox[3] > 63:
        errs.append('alpha bbox 越界 %r（不得碰 0/63）' % (bbox,))
    body = [(x, y) for (x, y) in opaque if px[x, y][:3] != OUTLINE[:3]]
    if not body:
        errs.append('无主体像素')
    else:
        bx0 = min(p[0] for p in body)
        by0 = min(p[1] for p in body)
        bx1 = max(p[0] for p in body)
        by1 = max(p[1] for p in body)
        if bx0 < 2 or by0 < 2 or bx1 > 61 or by1 > 61:
            errs.append('主体越界 (%d,%d,%d,%d)，要求 2..61' % (bx0, by0, bx1, by1))
    if len(colors) > art.MAX_COLORS:
        errs.append('用色 %d > %d' % (len(colors), art.MAX_COLORS))
    if len(opaque) < 200:
        errs.append('不透明像素 %d < 200' % len(opaque))
    # 外沿描边
    bad = []
    for (x, y) in opaque:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and px[nx, ny][3] == 0:
                if px[x, y][:3] != OUTLINE[:3]:
                    bad.append((x, y))
                break
    if bad:
        errs.append('外沿缺 #14181D 描边 %d 个（首个 %r）' % (len(bad), bad[0]))
    # 元素三色必须原样出现
    if entry['material'] in ELEMENT_KINDS:
        rgb = {c[:3] for c in colors}
        for name in ('base', 'light', 'dark'):
            want = art.hx(art.ELEMENT_COLORS[entry['variant']][name])[:3]
            if want not in rgb:
                errs.append('缺元素色 %s %s' % (name, art.to_hex(want + (255,))))
    return {
        'errors': errs,
        'size': im.size,
        'mode': 'RGBA',
        'colors': len(colors),
        'opaque': len(opaque),
        'bbox': bbox,
        'sha': _sha256(path),
    }


def _append_16_preview(sheet_path, items, cols=15, tile=96, gap=8, pad=24):
    """在 4× 接触表底部追加 16×16 实际尺寸预览（6× 最近邻放大），供 GUI 可读性复核。"""
    base = Image.open(sheet_path).convert('RGBA')
    rows = int(math.ceil(len(items) / float(cols)))
    label_h, title_h = 18, 38
    W = max(base.size[0], pad * 2 + cols * tile + (cols - 1) * gap)
    H = base.size[1] + title_h + rows * (tile + label_h + gap) + pad
    out = Image.new('RGBA', (W, H), (10, 13, 18, 255))
    out.alpha_composite(base, (0, 0))
    d = ImageDraw.Draw(out)
    y0 = base.size[1]
    d.line([pad, y0 + 8, W - pad, y0 + 8], fill=(44, 57, 68, 255), width=1)
    d.text((pad, y0 + 12), '16×16 实际尺寸（6× 最近邻放大；复核 GUI 可读性）',
           font=art.font(16, True), fill=(232, 239, 244, 255))
    for i, (path, label) in enumerate(items):
        r, c = divmod(i, cols)
        x = pad + c * (tile + gap)
        y = y0 + title_h + r * (tile + label_h + gap)
        im = Image.open(path).convert('RGBA').resize((16, 16), Image.NEAREST)
        im = im.resize((tile, tile), Image.NEAREST)
        cell = art.checker_board(tile, tile, 12)
        cell.alpha_composite(im, (0, 0))
        out.alpha_composite(cell, (x, y))
        d.rectangle([x, y, x + tile - 1, y + tile - 1], outline=(58, 70, 84, 255), width=1)
        d.text((x + 1, y + tile + 2), label, font=art.font(11), fill=(180, 198, 212, 255))
    out.save(sheet_path)
    return sheet_path


def main():
    with open(MANIFEST_PATH, encoding='utf-8') as f:
        manifest = json.load(f)
    entries = [e for e in manifest['entries'] if e.get('kind') == 'material']
    if len(entries) != 33:
        print('FAIL manifest 材料条目 %d，应为 33' % len(entries), file=sys.stderr)
        return 1

    # 清单覆盖 / CMD 段位
    problems = []
    for kind, cmds in EXPECTED_CMD.items():
        got = sorted(e['cmd'] for e in entries if e['material'] == kind)
        if got != cmds:
            problems.append('CMD %s=%r，应为 %r' % (kind, got, cmds))
        n = sum(1 for e in entries if e['material'] == kind)
        if n != EXPECTED_COUNT[kind]:
            problems.append('%s 数量 %d，应为 %d' % (kind, n, EXPECTED_COUNT[kind]))
    for e in entries:
        if e.get('variant') is None and e['material'] not in ('dust', 'sand', 'core'):
            problems.append('%s 缺 variant' % e['key'])
    if problems:
        for p in problems:
            print('FAIL ' + p, file=sys.stderr)
        return 1

    # 生成 + 落盘
    results = []
    for e in entries:
        canvas = draw_material(e)
        audit = canvas.audit()
        if not audit['ok']:
            print('FAIL 画布自检 %s: %s' % (e['key'], '; '.join(audit['errors'])),
                  file=sys.stderr)
            return 1
        path = os.path.join(PROJ, manifest['resourcepack_root'], e['texture'])
        canvas.save(path)
        results.append((e, path, check_entry(e, path)))

    # 文件数 / 逐张检查
    bad = [(e['key'], r['errors']) for e, p, r in results if r['errors']]
    for key, errs in bad:
        print('FAIL %s: %s' % (key, '; '.join(errs)), file=sys.stderr)
    if bad:
        return 1

    # 完全重复（字节级 sha256）
    by_sha = {}
    for e, p, r in results:
        by_sha.setdefault(r['sha'], []).append(e['key'])
    dups = {k: v for k, v in by_sha.items() if len(v) > 1}
    for k, v in dups.items():
        print('FAIL 完全重复：%s -> %s' % (k[:12], v), file=sys.stderr)
    if dups:
        return 1

    # 接触表（4×、带标签）
    label_entries = []
    for e, p, r in results:
        name = e['display_name']
        for code in ('§0', '§1', '§2', '§3', '§4', '§5', '§6', '§7', '§8', '§9',
                     '§a', '§b', '§c', '§d', '§e', '§f'):
            name = name.replace(code, '')
        label_entries.append({
            'path': p,
            'label': name,
            'sub': '%s · CMD %d' % (e['key'], e['cmd']),
        })
    art.contact_sheet(label_entries, SHEET_PATH, cols=6, scale=4,
                      title='镜中倒影 · 材料组 33 张（4×）')
    # 追加 16×16 实际尺寸复核行（GUI 尺寸下三对最近邻镜胚的可区分性）
    _append_16_preview(SHEET_PATH, [(p, e['key'].replace('mirror_', ''))
                                    for e, p, _ in results])
    sheet_im = Image.open(SHEET_PATH)
    if sheet_im.size[0] < 1:
        print('FAIL 接触表未生成', file=sys.stderr)
        return 1

    # 汇总
    print('manifest 材料条目 : %d' % len(entries))
    print('落盘文件          : %d  %s' %
          (len(results), os.path.join(manifest['resourcepack_root'], manifest['texture_root'])))
    print('尺寸/模式         : %s / %s（逐张）' %
          (sorted({r['size'] for _, _, r in results}),
           sorted({r['mode'] for _, _, r in results})))
    print('alpha bbox 范围   : x %d..%d, y %d..%d（getbbox 开区间）' %
          (min(r['bbox'][0] for _, _, r in results), max(r['bbox'][2] for _, _, r in results) - 1,
           min(r['bbox'][1] for _, _, r in results), max(r['bbox'][3] for _, _, r in results) - 1))
    print('用色              : %d..%d（上限 %d）' %
          (min(r['colors'] for _, _, r in results), max(r['colors'] for _, _, r in results),
           art.MAX_COLORS))
    print('不透明像素        : %d..%d（下限 200）' %
          (min(r['opaque'] for _, _, r in results), max(r['opaque'] for _, _, r in results)))
    print('完全重复          : %d' % len(dups))
    print('元素三色校验      : %d 张镜片/镜心全部含 base/light/dark 原值' %
          sum(1 for e, _, _ in results if e['material'] in ELEMENT_KINDS))
    print('接触表            : %s  %dx%d' % (SHEET_PATH, sheet_im.size[0], sheet_im.size[1]))
    print('audit             : PASS')
    for e, p, r in results:
        print('  %-22s CMD %3d  colors=%2d  opaque=%4d  bbox=%r' %
              (e['key'], e['cmd'], r['colors'], r['opaque'], r['bbox']))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
