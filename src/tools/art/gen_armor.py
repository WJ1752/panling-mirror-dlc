# -*- coding: utf-8 -*-
"""
gen_armor —— 《梦回盘灵：镜中倒影》防具组 24 张贴图生成器

范围（严格按 manifest.json 的「防具」组）：
  * 6 套 × 4 部位 = 24 张
  * CMD 200-223，顺序：照心→裂影→镜花→残影→双生→拓印，盔→甲→腿→靴
  * 落盘到 manifest.texture_root：<resourcepack_root>/assets/panling/textures/item/*.png
  * 接触表：out/art/sheet_armor.png（4×、带标签）

约束（《镜中倒影_美术规范_v1.0.md》）：
  * 64×64 RGBA、透明底、二值 alpha；
  * 主体（含描边）四周 1px 透明边；
  * 硬边、无抗锯齿；
  * 每图 ≤20 色；
  * 最外 1px 描边 #14181D；
  * 同套四件共用 motif_badge（同一 pattern / 同一色序 / 固定位置）；
  * 六套靠 轮廓 / 纹样 / 配色 三通道区分。

实现方式：
  以 mirror_art.draw_armor() 的规范底稿（§7.2 几何 + §5.2 纹样位置）为基底，
  再按套装追加“轮廓特征”：
    照心=圆形盘饰；裂影=锯齿尖刺；镜花=花瓣扇边；
    残影=偏移副轮廓+速度线；双生=中轴剖分+双圆；拓印=方形印章块。
  追加/削除后清掉旧描边，统一重描边并压色，保证最终图仍过 audit。

运行：
  python -I src/tools/art/gen_armor.py
"""

from __future__ import annotations

import hashlib
import itertools
import json
import math
import os
import sys

from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import mirror_art as A  # noqa: E402

PROJ = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
MANIFEST = os.path.join(HERE, 'manifest.json')
SHEET = os.path.join(PROJ, 'out', 'art', 'sheet_armor.png')

PARTS = ('helmet', 'chestplate', 'leggings', 'boots')
SET_ORDER = ('zhao', 'lie', 'jing', 'can', 'twin', 'rub')
PART_CN = {'helmet': '盔', 'chestplate': '甲', 'leggings': '腿', 'boots': '靴'}

M0, M1, M2, M3, M4 = A.MIRROR


# ---------------------------------------------------------------- 画布辅助

def _acc(style, i=0):
    return A.style_acc(style, i)


def _dark(style):
    return A.style_dark(style)


def _paper(style):
    return A.hx(style.get('paper', '#E8DFC8'))


def _paint(c, mask, color):
    return c.paint_mask(mask, color)


def _erase(c, mask):
    """把 mask 从主体中挖掉（用于做缺口/剖分/方形切角）。"""
    for x, y in mask:
        if c.in_bounds(x, y):
            c.px[y][x] = (0, 0, 0, 0)
            c.body.discard((x, y))


def _rect_mask(x0, y0, x1, y1):
    return {(x, y) for y in range(int(y0), int(y1) + 1)
            for x in range(int(x0), int(x1) + 1)}


def _clear_nonbody(c):
    """删掉旧描边：描边像素永远不在 c.body 里。"""
    for y in range(c.h):
        for x in range(c.w):
            if (x, y) not in c.body and c.px[y][x][3] != 0:
                c.px[y][x] = (0, 0, 0, 0)


def _shade(c, mask):
    """给新加的结构补左上高光 / 右下阴影（光源仍为左上）。"""
    c.edge_shade(mask, M3)
    c.edge_highlight(mask, M0)


def _thick_line(c, pts, color, width=2):
    return c.polyline(pts, color, width)


# ---------------------------------------------------------------- 轮廓特征
# 每个函数在 mirror_art.draw_armor() 的底稿上追加/削除形状。
# 只使用规范调色板（镜银 5 + 强调 2 + 暗色 + 拓印纸色 + 描边）。

def _zhao(c, style, part):
    """照心：圆镜盘。所有外沿改成圆盘/圆角，读作“圆”。"""
    if part == 'helmet':
        # 左右圆镜耳盘
        for cx in (10, 54):
            c.circle(cx, 32, 4.5, M2)
            c.circle(cx, 32, 3.2, M1)
            c.put(cx - 1, 31, M0)
        # 冠顶圆珠
        c.circle(32, 5, 3.0, M2)
        c.circle(32, 5, 2.0, M1)
        c.put(31, 4, M0)
        # 下沿圆盘（护颏/护颊收成圆弧）
        for cx, cy, r in ((13, 51, 3.0), (32, 52, 3.2), (51, 51, 3.0)):
            c.circle(cx, cy, r, M2)

    elif part == 'chestplate':
        # 圆肩扣
        for cx in (14, 50):
            c.circle(cx, 24, 4.0, M1)
            c.circle(cx, 24, 2.6, M2)
            c.put(cx - 1, 23, M0)
        # 圆摆：一整片弧形下摆（与镜花的三瓣摆拉开剪影）
        hem = {p for p in c.ellipse_mask(32, 54, 16, 6) if p[1] >= 52}
        _paint(c, hem, M2)
        c.line(26, 58, 38, 58, M1, 1)

    elif part == 'leggings':
        # 腰带两端圆头
        c.circle(16, 17, 4.5, M1)
        c.circle(48, 17, 4.5, M1)
        c.line(17, 13, 47, 13, M0, 1)
        # 侧挂圆镜片
        for cx, cy, r in ((11, 26, 3.6), (11, 44, 4.0),
                          (53, 26, 3.6), (53, 44, 4.0)):
            c.circle(cx, cy, r, M2)
            c.circle(cx, cy, max(1.0, r - 1.5), M1)
        # 膝部圆盘（压在膝带上，再补回强调线）
        for cx in (24, 40):
            c.circle(cx, 43, 3.2, M2)
        c.line(20, 42, 28, 42, _acc(style, 0), 1)
        c.line(36, 42, 44, 42, _acc(style, 0), 1)
        # 裤脚圆角
        for cx in (24, 40):
            c.circle(cx, 57, 3.4, M1)

    else:  # boots
        # 圆头鞋尖
        for cx in (21, 43):
            c.circle(cx, 55, 4.5, M2)
            c.circle(cx - 1, 54, 3.0, M1)
        # 圆跟
        for cx in (11, 53):
            c.circle(cx, 55, 3.0, M2)
        for cx in (10, 54):
            c.circle(cx, 49, 3.5, M2)
        # 靴口圆角
        for cx in (14, 28, 36, 50):
            c.circle(cx, 23, 3.0, M1)


def _lie(c, style, part):
    """裂影：斜向折线/碎片的外化——锯齿、尖刺、断口。"""
    if part == 'helmet':
        # 冠饰分叉 + 中缝断口
        _erase(c, _rect_mask(31, 2, 32, 13))
        c.poly([(26, 4), (31, 4), (27, 12), (23, 15)], _acc(style, 0))
        c.poly([(33, 4), (38, 4), (41, 15), (37, 12)], _acc(style, 0))
        c.line(27, 5, 27, 12, _acc(style, 1), 1)
        c.line(37, 5, 38, 12, _acc(style, 1), 1)
        # 左右锯齿（各 3 枚）
        for (x0, y0, x1, y1, x2, y2) in (
                (13, 21, 6, 19, 13, 28),
                (11, 30, 4, 29, 11, 37),
                (12, 37, 6, 41, 14, 43)):
            c.poly([(x0, y0), (x1, y1), (x2, y2)], M2)
            c.poly([(64 - x0, y0), (64 - x1, y1), (64 - x2, y2)], M2)
        # 护颊下尖
        c.poly([(12, 48), (10, 55), (17, 50)], M2)
        c.poly([(52, 48), (54, 55), (47, 50)], M2)

    elif part == 'chestplate':
        # 肩甲尖刺
        for (x0, y0, x1, y1, x2, y2) in (
                (5, 19, 2, 13, 11, 17),
                (4, 27, 2, 33, 10, 30),
                (14, 15, 11, 10, 18, 14)):
            c.poly([(x0, y0), (x1, y1), (x2, y2)], M2)
            c.poly([(64 - x0, y0), (64 - x1, y1), (64 - x2, y2)], M2)
        # 下摆锯齿
        for x in (23, 35):
            c.poly([(x, 52), (x + 3, 58), (x + 6, 52)], M2)
        # 侧摆尖
        c.poly([(14, 50), (17, 57), (21, 52)], M2)
        c.poly([(50, 50), (47, 57), (43, 52)], M2)

    elif part == 'leggings':
        # 腿甲外侧 3 枚锯齿
        for (x0, y0, x1, y1, x2, y2) in (
                (19, 33, 12, 36, 20, 40),
                (19, 42, 13, 45, 20, 47),
                (20, 50, 14, 53, 21, 55)):
            c.poly([(x0, y0), (x1, y1), (x2, y2)], M1)
            c.poly([(64 - x0, y0), (64 - x1, y1), (64 - x2, y2)], M1)
        # 侧挂镜片下端尖
        c.poly([(7, 43), (11, 52), (15, 43)], M2)
        c.poly([(57, 43), (53, 52), (49, 43)], M2)
        # 膝带折线（强调色）
        c.line(20, 42, 24, 45, _acc(style, 0), 1)
        c.line(24, 45, 28, 42, _acc(style, 1), 1)
        c.line(36, 42, 40, 45, _acc(style, 0), 1)
        c.line(40, 45, 44, 42, _acc(style, 1), 1)

    else:  # boots
        # 尖头鞋
        c.poly([(11, 49), (2, 56), (12, 57), (15, 53)], M2)
        c.poly([(53, 49), (62, 56), (52, 57), (49, 53)], M2)
        # 后跟尖刺
        c.poly([(14, 41), (7, 38), (11, 47)], M2)
        c.poly([(50, 41), (57, 38), (53, 47)], M2)
        # 靴口锯齿
        for x0 in (14, 22):
            c.poly([(x0, 22), (x0 + 3, 16), (x0 + 6, 22)], M1)
            c.poly([(64 - x0, 22), (64 - x0 - 3, 16), (64 - x0 - 6, 22)], M1)


def _jing(c, style, part):
    """镜花：五瓣花 + 水月弧的外化——花瓣扇边。"""
    if part == 'helmet':
        # 单片叶形冠饰（冠饰只做粉色冠，不与额心五瓣花抢读）
        _erase(c, _rect_mask(26, 2, 38, 13))
        c.poly([(32, 3), (36, 7), (35, 14), (29, 14), (28, 7)], _acc(style, 0))
        c.line(32, 5, 32, 13, _acc(style, 1), 1)
        c.put(31, 6, M0)
        # 左右扇边（各 3 瓣）
        for cx, cy, r in ((12, 27, 4.0), (9, 34, 4.0), (12, 41, 4.0)):
            c.circle(cx, cy, r, M2)
            c.circle(64 - cx, cy, r, M2)
        # 下沿花瓣
        for cx, cy, r in ((20, 52, 3.0), (32, 53, 3.2), (44, 52, 3.0)):
            c.circle(cx, cy, r, M2)

    elif part == 'chestplate':
        # 花瓣肩（3 瓣）
        for cx, cy, r in ((7, 25, 4.0), (13, 20, 4.0), (20, 25, 4.0)):
            c.circle(cx, cy, r, M2)
            c.circle(64 - cx, cy, r, M2)
        # 花瓣下摆
        for cx, cy, r in ((23, 53, 4.0), (32, 54, 4.0), (41, 53, 4.0)):
            c.circle(cx, cy, r, M2)
        # 侧摆弧
        c.arc(17, 48, 5, 20, 160, M1)
        c.arc(47, 48, 5, 20, 160, M1)

    elif part == 'leggings':
        # 侧挂花瓣片
        for cx, cy, r in ((11, 27, 3.6), (9, 34, 3.6), (11, 41, 3.6)):
            c.circle(cx, cy, r, M2)
            c.circle(64 - cx, cy, r, M2)
        # 髋部下沿花瓣
        for cx, cy, r in ((20, 33, 3.2), (32, 34, 3.2), (44, 33, 3.2)):
            c.circle(cx, cy, r, M2)
        # 裤脚花瓣（向外扩，形成喇叭形剪影）
        for cx, cy, r in ((18, 58, 3.5), (23, 57, 3.0), (29, 57, 3.0),
                          (35, 57, 3.0), (41, 57, 3.0), (46, 58, 3.5)):
            c.circle(cx, cy, r, M1)

    else:  # boots
        # 靴口三瓣
        for cx, cy, r in ((15, 23, 3.0), (21, 20, 3.0), (27, 23, 3.0)):
            c.circle(cx, cy, r, M1)
            c.circle(64 - cx, cy, r, M1)
        # 鞋头花瓣
        for cx, cy, r in ((17, 55, 3.0), (21, 57, 3.2), (25, 55, 3.0)):
            c.circle(cx, cy, r, M2)
            c.circle(64 - cx, cy, r, M2)
        # 鞋跟弧
        c.arc(11, 55, 3, 20, 160, M2)
        c.arc(53, 55, 3, 20, 160, M2)


def _ghost_fins(c, style, part):
    """残影副轮廓：贴住主体的 2–4px 偏移鳍片；不画速度线，避免 16×16 噪声。"""
    a0, a1 = _acc(style, 0), _acc(style, 1)
    if part == 'helmet':
        c.poly([(52, 30), (58, 28), (58, 37), (57, 44), (54, 47),
                (54, 40), (55, 34)], a1)
        c.line(57, 30, 57, 43, a0, 1)
    elif part == 'chestplate':
        c.poly([(45, 36), (51, 39), (51, 48), (46, 52),
                (47, 46), (47, 40)], a1)
        c.line(50, 41, 50, 47, a0, 1)
        # 残影尾鳍：细长、贴住右腰，拉长剪影但不堆深青块
        c.poly([(46, 50), (52, 53), (50, 58), (45, 55)], a1)
        c.line(50, 54, 49, 57, a0, 1)
    elif part == 'leggings':
        c.poly([(45, 46), (50, 48), (50, 54), (46, 57),
                (45, 53), (46, 50)], a1)
        c.line(49, 50, 49, 54, a0, 1)
        c.poly([(8, 32), (5, 34), (5, 39), (8, 42), (7, 37)], a1)
        c.line(6, 35, 6, 38, a0, 1)
    else:  # boots
        c.poly([(51, 32), (57, 34), (57, 44), (53, 53),
                (52, 46), (53, 40)], a1)
        c.line(56, 36, 56, 43, a0, 1)


def _ghost(c, style, part):
    """残影：偏移副轮廓（贴边鳍片），不再画游离速度线。"""
    _ghost_fins(c, style, part)
    if part == 'helmet':
        # 后掠冠
        c.poly([(28, 4), (39, 5), (34, 11), (30, 22)], _acc(style, 0))
        c.line(29, 6, 33, 6, _acc(style, 1), 1)


def _ghost_post(c, style, part):
    """着色/高光之后重绘副轮廓，保证它仍是青/深青而不是镜银高光。"""
    _ghost_fins(c, style, part)


def _jing_post(c, style, part):
    """镜花：给额心/靴踝的五瓣花垫一块镜银盘，避免与冠饰/踝带糊成粉块。"""
    if part == 'helmet':
        c.circle(32, 24, 6.0, M2)
        c.circle(32, 24, 5.1, M1)
        c.put(30, 22, M0)
    elif part == 'boots':
        for cx in (21, 43):
            c.circle(cx, 27, 5.0, M2)
            c.circle(cx, 27, 4.1, M1)
            c.put(cx - 2, 25, M0)


def _jing_flower(c, cx, cy, r, style):
    """镜花五瓣花 + 水月弧。

    与 mirror_art.motif_badge('flower') 同母题（5 瓣 + 白心 + 2 条弧），
    仅在小尺寸（r≈3.6/4.5）收窄花瓣，避免 5 瓣糊成一个粉块。
    四件同套都调用本函数，pattern/色序/位置一致。
    """
    pink, ivory = _acc(style, 0), _acc(style, 1)
    pr = max(1.0, r * 0.26)
    d = r * 0.66
    for i in range(5):
        a = math.radians(-90 + 72 * i)
        c.circle(cx + math.cos(a) * d, cy - 1 + math.sin(a) * d, pr, pink)
    c.circle(cx, cy - 1, max(1.0, r * 0.30), ivory)
    c.arc(cx, cy + 2, r - 1, 20, 160, ivory)
    c.arc(cx, cy + 3, r - 3, 20, 160, M0)


def _can_badge(c, cx, cy, r, style):
    """残影偏移双轮廓：两个错位实心圆（后深青/前青），16×16 保持单块；
    速度线按审读意见删除，轮廓识别交给本徽记 + 贴边鳍片。"""
    a0, a1 = _acc(style, 0), _acc(style, 1)
    c.circle(cx - 1, cy - 1, r - 1, a1)
    c.circle(cx + 1, cy + 1, r, a0)
    c.put(cx + 1, cy + 1, M0)


def _rub_seal_fix(c, cx, cy, r, style):
    """方印统一为“3 横 1 竖”：重画内方纸色与印纹，四件同 pattern。"""
    ink = _acc(style, 1)
    x0, y0 = int(cx - r), int(cy - r)
    x1, y1 = int(cx + r), int(cy + r)
    ix0, iy0, ix1, iy1 = x0 + 1, y0 + 1, x1 - 1, y1 - 1
    c.rect(ix0, iy0, ix1, iy1, _paper(style))
    h = iy1 - iy0 + 1
    if h <= 7:
        rows = [iy0 + 1, iy0 + 3, iy0 + 5]
    else:
        rows = [iy0 + 1, iy0 + h // 2, iy0 + h - 2]
    for y in rows:
        c.line(ix0 + 1, y, ix1 - 1, y, ink, 1)
    c.line(cx, rows[0], cx, rows[-1], ink, 1)


def _bands(c, style, part):
    """四件同套的强调边带（腿膝 / 靴踝）在 16×16 仍可读：亮线加粗到 2px。"""
    a0, a1 = _acc(style, 0), _acc(style, 1)
    twin = style['key'] == 'twin'
    if part == 'chestplate':
        # 腰封下缘：64→16 取样落在 y=50，保证“甲腰”在 16×16 仍可见
        if twin:
            c.line(23, 50, 31, 50, a0)
            c.line(33, 50, 41, 50, a1)
        else:
            c.line(23, 50, 41, 50, a0)
    elif part == 'leggings':
        c.rect(20, 42, 28, 43, a0)
        c.rect(36, 42, 44, 43, a1 if twin else a0)
    elif part == 'boots':
        # 上下两道 1px 踝环：64→16 最近邻取样落在 y=34，必须让该行也有强调色
        for y in (32, 34):
            c.line(13, y, 29, y, a0)
            c.line(35, y, 51, y, a1 if twin else a0)


def _twin(c, style, part):
    """双生：中轴剖分 + 双圆；左金右蓝，不反转。"""
    gold, blue = _acc(style, 0), _acc(style, 1)
    if part == 'helmet':
        # 冠部中缝剖开
        _erase(c, _rect_mask(31, 2, 33, 14))
        c.poly([(26, 8), (30, 8), (30, 22), (26, 22)], gold)
        c.poly([(34, 8), (38, 8), (38, 22), (34, 22)], blue)
        for cx, col in ((28, gold), (36, blue)):
            c.circle(cx, 6, 3.6, col)
            c.circle(cx, 6, 2.2, M1)
            c.put(cx - 1, 5, M0)
    elif part == 'chestplate':
        # 下摆中轴 V 形剖开
        _erase(c, c.poly([(28, 53), (32, 45), (36, 53)], (0, 0, 0, 0)))  # noqa: E501
        # 腰扣左右半（金/蓝）
        c.rect(28, 47, 31, 51, gold)
        c.rect(33, 47, 36, 51, blue)
        # 方形肩线，呼应“双半”
        c.rect(4, 18, 20, 20, M2)
        c.rect(44, 18, 60, 20, M2)

    elif part == 'leggings':
        # 双腿之间补一条对称中带（左右各半色）
        c.rect(30, 33, 34, 44, M2)
        c.line(31, 33, 31, 44, gold, 1)
        c.line(33, 33, 33, 44, blue, 1)
        c.put(32, 34, M1)
    else:  # boots
        # 鞋头/靴筒中缝剖开
        _erase(c, _rect_mask(20, 50, 22, 57))
        _erase(c, _rect_mask(42, 50, 44, 57))
        # 方形鞋面
        c.rect(10, 50, 30, 52, M2)
        c.rect(34, 50, 54, 52, M2)


def _rub(c, style, part):
    """拓印：方形印章/纸纹的外化——方冠、方肩、方摆、纸签。"""
    a0, a1, paper = _acc(style, 0), _acc(style, 1), _paper(style)
    if part == 'helmet':
        # 方形印冠
        c.rect(26, 3, 38, 10, a0)
        c.rect(28, 5, 36, 8, paper)
        c.line(30, 6, 34, 6, a1, 1)
        # 方形侧板
        c.rect(7, 24, 11, 38, M2)
        c.rect(53, 24, 57, 38, M2)
        c.line(8, 27, 8, 35, M1, 1)
        c.line(55, 27, 55, 35, M1, 1)
        # 方形护颊下摆
        c.rect(12, 48, 20, 54, M2)
        c.rect(44, 48, 52, 54, M2)

    elif part == 'chestplate':
        # 方肩线
        c.rect(4, 17, 24, 20, M2)
        c.rect(40, 17, 60, 20, M2)
        c.line(5, 18, 23, 18, M1, 1)
        c.line(41, 18, 59, 18, M1, 1)
        # 甲腰强调带（保持四件同套的“甲腰”识别通道）
        c.rect(22, 46, 42, 52, _dark(style))
        c.line(23, 47, 41, 47, a0, 1)
        c.rect(30, 47, 34, 51, a0)
        # 方形下摆
        c.rect(17, 52, 47, 56, M2)

        # 纸签
        c.rect(27, 52, 37, 58, paper)
        c.rect(28, 53, 36, 55, a1)
        c.line(30, 54, 34, 54, paper, 1)
        # 侧摆方块
        c.rect(13, 44, 19, 51, M2)
        c.rect(45, 44, 51, 51, M2)

    elif part == 'leggings':
        # 方形髋块 + 方形侧板
        c.rect(14, 22, 18, 33, M2)
        c.rect(46, 22, 50, 33, M2)
        c.rect(7, 25, 15, 44, M2)
        c.rect(9, 27, 13, 33, M1)
        c.rect(49, 25, 57, 44, M2)
        c.rect(51, 27, 55, 33, M1)
        c.line(8, 44, 14, 44, a0, 1)
        c.line(50, 44, 56, 44, a0, 1)
        # 纸签（腰带下垂）
        c.rect(19, 33, 24, 40, paper)
        c.rect(40, 33, 45, 40, paper)
        c.line(19, 38, 24, 38, a1, 1)
        c.line(40, 38, 45, 38, a1, 1)
        # 方形裤脚
        c.rect(19, 57, 30, 60, M1)
        c.rect(34, 57, 45, 60, M1)

    else:  # boots
        # 方形鞋头
        c.rect(9, 52, 31, 57, M2)
        c.rect(33, 52, 55, 57, M2)
        c.line(10, 52, 30, 52, M1, 1)
        c.line(34, 52, 54, 52, M1, 1)
        # 方形靴口
        c.rect(11, 22, 30, 24, M1)
        c.rect(34, 22, 53, 24, M1)
        # 纸签
        c.rect(8, 30, 12, 39, paper)
        c.rect(52, 30, 56, 39, paper)
        c.line(8, 37, 12, 37, a1, 1)
        c.line(52, 37, 56, 37, a1, 1)


_MODS = {
    'zhao': _zhao,
    'lie': _lie,
    'jing': _jing,
    'can': _ghost,
    'twin': _twin,
    'rub': _rub,
}

_POST = {
    'can': _ghost_post,
    'jing': _jing_post,
}

# 纹样固定落点（规范 §5.2）
BADGES = {
    'helmet': ((32, 24, 4.5),),
    'chestplate': ((32, 33, 7.0),),
    'leggings': ((32, 18, 5.0),),
    'boots': ((21, 27, 3.6), (43, 27, 3.6)),
}


# ---------------------------------------------------------------- 组装

def build(style, part):
    if part not in PARTS:
        raise ValueError('unknown armor part: %r' % part)
    c = A.draw_armor(style, part)     # 规范底稿（几何 + 强调边带 + motif）
    _clear_nonbody(c)                 # 清旧描边，准备改轮廓
    _MODS[style['key']](c, style, part)
    # 轮廓特征统一补光/压暗，保持左上光源
    _shade(c, set(c.body))
    _bands(c, style, part)
    if style['key'] in _POST:
        _POST[style['key']](c, style, part)
    # 纹样最后重画：保证四件同套 pattern/色序/位置绝对一致，不被轮廓特征盖住
    for cx, cy, r in BADGES[part]:
        if style['key'] == 'jing':
            _jing_flower(c, cx, cy, r, style)
        elif style['key'] == 'can':
            _can_badge(c, cx, cy, r, style)
        else:
            A.motif_badge(c, cx, cy, r, style)
        if style['key'] == 'rub':
            _rub_seal_fix(c, cx, cy, r, style)
    _clear_nonbody(c)
    c.outline(A.OUTLINE)
    c.enforce_color_limit(A.MAX_COLORS)
    return c


# ---------------------------------------------------------------- 自检

def _iou(mask_a, mask_b):
    inter = len(mask_a & mask_b)
    union = len(mask_a | mask_b)
    return inter / float(union) if union else 1.0


def _alpha_mask(path):
    im = Image.open(path).convert('RGBA')
    px = im.load()
    return {(x, y) for y in range(im.size[1]) for x in range(im.size[0])
            if px[x, y][3] > 0}


def _downsample_stats(path, n=16):
    im = Image.open(path).convert('RGBA')
    small = im.resize((n, n), Image.NEAREST)
    sp = small.load()
    opaque = [sp[x, y] for y in range(n) for x in range(n) if sp[x, y][3] > 0]
    return {
        'opaque': len(opaque),
        'colors': len({p for p in opaque}),
    }


def check_entries(entries):
    """manifest 结构校验：24 条、CMD 200-223、顺序、路径唯一。"""
    errors = []
    if len(entries) != 24:
        errors.append('防具条目应为 24，实际 %d' % len(entries))
    expected = []
    for si, key in enumerate(SET_ORDER):
        for pi, part in enumerate(PARTS):
            expected.append((200 + si * 4 + pi, key, part))
    for entry, (cmd, key, part) in zip(entries, expected):
        if entry['cmd'] != cmd or entry['set'] != key or entry['part'] != part:
            errors.append('顺序不符：期望 %d/%s/%s，实际 %s/%s/%s' % (
                cmd, key, part, entry['cmd'], entry['set'], entry['part']))
        want_key = 'mirror_%s_%s' % (key, part)
        if entry['key'] != want_key:
            errors.append('key 不符：%s != %s' % (entry['key'], want_key))
        if entry['texture'] != 'assets/panling/textures/item/%s.png' % want_key:
            errors.append('texture 路径不符：%s' % entry['texture'])
    paths = [e['texture'] for e in entries]
    if len(set(paths)) != len(paths):
        errors.append('texture 路径有重复')
    # 同套四件 motif / accent 必须完全一致
    for key in SET_ORDER:
        group = [e for e in entries if e['set'] == key]
        if len(group) != 4:
            errors.append('%s 套装条目数 %d != 4' % (key, len(group)))
        if len({e['motif'] for e in group}) != 1:
            errors.append('%s 四件 motif 不一致' % key)
        if len({tuple(e['accent']) for e in group}) != 1:
            errors.append('%s 四件 accent 不一致' % key)
    return errors


def _append_16_preview(sheet_path, items, cols=6, tile=64, gap=4, pad=24):
    """在 4× 接触表底部追加 16×16 实际尺寸区（6 列 × 4 行，4× 最近邻放大）。"""
    base = Image.open(sheet_path).convert('RGBA')
    rows = int(math.ceil(len(items) / float(cols)))
    label_h, title_h = 16, 34
    W = max(base.size[0], pad * 2 + cols * tile + (cols - 1) * gap)
    H = base.size[1] + title_h + rows * (tile + label_h + gap) + pad
    out = Image.new('RGBA', (W, H), (10, 13, 18, 255))
    out.alpha_composite(base, (0, 0))
    d = ImageDraw.Draw(out)
    y0 = base.size[1]
    d.line([pad, y0 + 8, W - pad, y0 + 8], fill=(44, 57, 68, 255), width=1)
    d.text((pad, y0 + 12), '16×16 实际尺寸（4× 最近邻放大；6 列 × 4 行；复核 GUI 可读性）',
           font=A.font(16, True), fill=(232, 239, 244, 255))
    grid_w = cols * tile + (cols - 1) * gap
    x_start = max(pad, (W - grid_w) // 2)
    for i, (path, label) in enumerate(items):
        r, c = divmod(i, cols)
        x = x_start + c * (tile + gap)
        y = y0 + title_h + r * (tile + label_h + gap)
        im = Image.open(path).convert('RGBA').resize((16, 16), Image.NEAREST)
        im = im.resize((tile, tile), Image.NEAREST)
        cell = A.checker_board(tile, tile, 8)
        cell.alpha_composite(im, (0, 0))
        out.alpha_composite(cell, (x, y))
        d.rectangle([x, y, x + tile - 1, y + tile - 1], outline=(58, 70, 84, 255), width=1)
        d.text((x + 1, y + tile + 2), label, font=A.font(10), fill=(180, 198, 212, 255))
    out.save(sheet_path)
    return sheet_path


def run():
    with open(MANIFEST, encoding='utf-8') as fh:
        manifest = json.load(fh)
    entries = [e for e in manifest['entries'] if e.get('category') == 'armor']
    errors = check_entries(entries)

    rp_root = os.path.join(PROJ, manifest['resourcepack_root'])
    out_paths = []
    reports = []
    hashes = {}
    for e in entries:
        style = A.SET_STYLE[e['set']]
        c = build(style, e['part'])
        dst = os.path.join(rp_root, e['texture'])
        c.save(dst)
        out_paths.append(dst)

        r = A.audit_icon_file(dst)
        ds = _downsample_stats(dst)
        im = Image.open(dst)
        mode, size = im.mode, im.size
        # 16×16 下强调色是否还活着（规范 §2.5：套别不能只靠 1px 线）
        im16 = im.convert('RGBA').resize((16, 16), Image.NEAREST)
        p16 = [im16.getpixel((x, y)) for y in range(16) for x in range(16)]
        acc0 = A.hx(style['accent'][0])
        acc1 = A.hx(style['accent'][1])
        accent16 = {
            'a0': sum(1 for p in p16 if p == acc0),
            'a1': sum(1 for p in p16 if p == acc1),
        }
        digest = hashlib.sha256(open(dst, 'rb').read()).hexdigest()
        hashes.setdefault(digest, []).append(e['key'])
        reports.append({
            'cmd': e['cmd'], 'key': e['key'], 'part': e['part'], 'set': e['set'],
            'ok': r['ok'], 'colors': r['colors'], 'opaque': r['opaque_pixels'],
            'bbox': r['bbox'], 'coverage': r['coverage'], 'mode': mode, 'size': list(size),
            'small16': ds, 'accent16': accent16,
            'errors': r['errors'], 'warnings': r['warnings'],
            'path': os.path.relpath(dst, PROJ).replace('\\', '/'),
        })
        if not r['ok']:
            errors.extend(['%s: %s' % (e['key'], msg) for msg in r['errors']])
        if r['colors'] > A.MAX_COLORS:
            errors.append('%s: 用色 %d > %d' % (e['key'], r['colors'], A.MAX_COLORS))
        if r['opaque_pixels'] < 200:
            errors.append('%s: 不透明像素 %d < 200' % (e['key'], r['opaque_pixels']))
        if mode != 'RGBA' or size != (64, 64):
            errors.append('%s: 模式/尺寸 %s %r 不是 64×64 RGBA' % (e['key'], mode, size))
        if r['bbox'] is None or r['bbox'][0] < 1 or r['bbox'][1] < 1 or                 r['bbox'][2] > 62 or r['bbox'][3] > 62:
            errors.append('%s: alpha bbox %r 超出 1..62（无 1px 透明边）' % (e['key'], r['bbox']))
        if ds['opaque'] < 40:
            errors.append('%s: 16×16 预览不透明像素 %d 过少' % (e['key'], ds['opaque']))
        if accent16['a0'] < 3:
            errors.append('%s: 16×16 主强调色只剩 %d px' % (e['key'], accent16['a0']))
        if e['set'] == 'twin' and accent16['a1'] < 3:
            errors.append('%s: 16×16 双生蓝只剩 %d px（双子必须金蓝同现）' % (e['key'], accent16['a1']))

    dup = {d: ks for d, ks in hashes.items() if len(ks) > 1}
    if dup:
        errors.append('存在完全重复的贴图：%r' % dup)

    # 六套轮廓区分：同部位两两 alpha 剪影 IoU
    by_key = {e['key']: p for e, p in zip(entries, out_paths)}
    sil = {}
    for part in PARTS:
        pairs = {}
        for a, b in itertools.combinations(SET_ORDER, 2):
            pa = by_key['mirror_%s_%s' % (a, part)]
            pb = by_key['mirror_%s_%s' % (b, part)]
            pairs[(a, b)] = round(_iou(_alpha_mask(pa), _alpha_mask(pb)), 3)
        sil[part] = pairs

    for part, pairs in sil.items():
        worst_key, worst_val = max(pairs.items(), key=lambda kv: kv[1])
        if worst_val >= 0.95:
            errors.append('轮廓通道不足：%s 最大 IoU %.3f（%s）≥ 0.95' % (
                part, worst_val, worst_key))

    if len({e['motif'] for e in entries}) != 6:
        errors.append('六套纹样没有 6 个不同值')

    # 配色通道：主/副强调色两两距离（与规范 §13.2 同口径）
    def rgb(h):
        return A.hx(h)[:3]

    def dist(a, b):
        return sum((a[i] - b[i]) ** 2 for i in range(3)) ** 0.5

    color_pairs = {}
    for a, b in itertools.combinations(SET_ORDER, 2):
        sa, sb = A.SET_STYLE[a], A.SET_STYLE[b]
        color_pairs[(a, b)] = {
            'primary': round(dist(rgb(sa['accent'][0]), rgb(sb['accent'][0])), 1),
            'secondary': round(dist(rgb(sa['accent'][1]), rgb(sb['accent'][1])), 1),
        }

    for pair, d in color_pairs.items():
        if max(d['primary'], d['secondary']) < 40:
            errors.append('配色通道不足：%s 主/副色距均 < 40（%r）' % (pair, d))

    # 接触表（4×、带标签）
    sheet_entries = []
    for r in reports:
        sheet_entries.append({
            'path': os.path.join(PROJ, r['path']),
            'label': '%d  %s' % (r['cmd'], A.SET_STYLE[r['set']]['name'] + '镜·' + PART_CN[r['part']]),
            'sub': '%s · %d色 · %dpx · 16px:%d' % (r['part'], r['colors'], r['opaque'], r['small16']['opaque']),
        })
    A.contact_sheet(sheet_entries, SHEET, cols=4, scale=4,
                    title='镜中倒影 · 防具 24 件（CMD 200–223）')
    _append_16_preview(SHEET, [(r['path'], '%d %s' % (
        r['cmd'], A.SET_STYLE[r['set']]['name'] + '·' + PART_CN[r['part']]))
        for r in reports])
    for r in reports:
        print('%-3d %-26s %-10s ok=%s colors=%2d opaque=%4d bbox=%s 16px=%d' % (
            r['cmd'], r['key'], r['part'], r['ok'], r['colors'], r['opaque'],
            str(r['bbox']), r['small16']['opaque']))

    summary = {
        'count': len(out_paths),
        'sheet': os.path.relpath(SHEET, PROJ).replace('\\', '/'),
        'errors': errors,
        'silhouette_iou': sil,
        'color_distance': color_pairs,
        'reports': reports,
    }
    print('\n=== summary ===')
    print('count=%d sheet=%s' % (summary['count'], summary['sheet']))
    for part in PARTS:
        vals = list(sil[part].values())
        worst = max(sil[part].items(), key=lambda kv: kv[1])
        print('silhouette %-10s min=%.3f max=%.3f %s' % (
            part, min(vals), max(vals), worst))
    for r in reports:
        print('16px accent %-3d %-26s a0=%2d a1=%2d mode=%s size=%s' % (
            r['cmd'], r['key'], r['accent16']['a0'], r['accent16']['a1'],
            r['mode'], r['size']))
    print('color primary min=%.1f secondary min=%.1f' % (
        min(v['primary'] for v in color_pairs.values()),
        min(v['secondary'] for v in color_pairs.values())))
    if errors:
        print('\nFAIL:')
        for msg in errors:
            print('  ! ' + msg)
        return 1
    print('\nALL PASS: 24/24 audit ok, no duplicate, colors<=20, opaque>=200')
    return 0


if __name__ == '__main__':
    raise SystemExit(run())
