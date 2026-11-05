# -*- coding: utf-8 -*-
"""
mirror_art —— 《梦回盘灵：镜中倒影》物品图标共用画具

设计口径（与《镜中倒影_美术规范_v1.0.md》一致）：
  * 64×64 RGBA，透明底，主体（含描边）四周留 1px 透明边距；
  * 硬边像素、二值 alpha、无抗锯齿；
  * 每张图最多 20 色；
  * 最外层 1px 描边 #14181D；
  * 统一光源左上：左上高光、右下阴影；
  * 镜银主色阶 + 六套强调色。

坐标约定：
  * (0,0) 为左上角；x 向右、y 向下；
  * 所有形状先画“主体”，最后统一加外描边；
  * 主体只允许画在 [2, 61]，描边占 [1, 62]，因此最外圈 [0, 63] 恒为透明。

对外 API：
  Canvas                 画布（像素/矩形/线/多边形/圆/椭圆/弧/描边/高光/阴影/反光/裂纹）
  SET_STYLE              六套强调色与纹样元数据
  ELEMENT_COLORS         五行元素色映射
  motif_badge            六套共用纹样徽记（四件同套必须调用同一个）
  seal_stamp             方形印章（纸符/定影符共用）
  draw_sword / draw_axe / draw_bow / draw_crossbow /
  draw_twin_furnace / draw_rub_furnace / draw_armor / draw_material
  build_icon             按 manifest 条目分发到具体画具
  audit_icon / audit_icon_file / silhouette_iou
  contact_sheet          4×、带标签、深色棋盘底的接触表

用法：
  from mirror_art import draw_sword, SET_STYLE
  c = draw_sword(SET_STYLE['zhao'])
  c.save('out/art/sample_sword.png')
"""
from __future__ import annotations

import argparse
import json
import math
import os
import random
from contextlib import contextmanager

from PIL import Image, ImageDraw, ImageFont

# ---------------------------------------------------------------- 基本常量

ICON_SIZE = 64
MARGIN = 1                 # 最外圈透明边距（含描边）
BODY_INSET = MARGIN + 1    # 主体绘制内缩：给 1px 描边留位置
MAX_COLORS = 20
OUTLINE_HEX = "#14181D"
OUTLINE = (0x14, 0x18, 0x1D, 0xFF)

MIRROR_HEX = ("#F4FBFF", "#CFE0E8", "#9DB2BE", "#5C7180", "#2C3944")
MIRROR = tuple(tuple(int(h[i:i + 2], 16) for i in (1, 3, 5)) + (255,) for h in MIRROR_HEX)

SET_STYLE = {
    'zhao': {
        'name': '照心', 'key': 'zhao', 'pattern': 'rings',
        'accent': ('#F2D48A', '#FFF6E0'), 'accent_dark': '#A87C2E',
        'motif': '圆镜盘+同心波纹', 'weapon': '照心镜剑', 'armor': '照心镜',
        'weapon_builder': 'sword',
    },
    'lie': {
        'name': '裂影', 'key': 'lie', 'pattern': 'crack',
        'accent': ('#A46BE8', '#E05FA8'), 'accent_dark': '#5E3A85',
        'motif': '斜向折线裂痕+碎片', 'weapon': '裂影镜斧', 'armor': '裂影镜',
        'weapon_builder': 'axe',
    },
    'jing': {
        'name': '镜花', 'key': 'jing', 'pattern': 'flower',
        'accent': ('#F2A7C3', '#FFF0F5'), 'accent_dark': '#B05C7C',
        'motif': '五瓣花+水月弧', 'weapon': '镜花境弓', 'armor': '镜花轻甲',
        'weapon_builder': 'bow',
    },
    'can': {
        'name': '残影', 'key': 'can', 'pattern': 'ghost',
        'accent': ('#5FD6E8', '#1F6F78'), 'accent_dark': '#134A50',
        'motif': '偏移双轮廓+速度线', 'weapon': '残影镜弩', 'armor': '残影轻甲',
        'weapon_builder': 'crossbow',
    },
    'twin': {
        'name': '双生', 'key': 'twin', 'pattern': 'twin',
        'accent': ('#E8C060', '#5A8FE8'), 'accent_dark': '#2F5AA8',
        'motif': '左右对称双半+双圆', 'weapon': '双生镜炉', 'armor': '双生镜袍',
        'weapon_builder': 'twin_furnace',
    },
    'rub': {
        'name': '拓印', 'key': 'rub', 'pattern': 'stamp',
        'accent': ('#C8483C', '#2B2B2B'), 'accent_dark': '#7A2A24',
        'paper': '#E8DFC8',
        'motif': '方形印章+纸纹', 'weapon': '拓印镜炉', 'armor': '拓印镜袍',
        'weapon_builder': 'rub_furnace',
    },
}

SET_ORDER = ('zhao', 'lie', 'jing', 'can', 'twin', 'rub')

ELEMENT_COLORS = {
    # 金＝铁/黄铜；木＝苔石/藤；水＝海晶/冰；火＝黑石/岩浆；土＝砂岩/陶瓦
    'metal': {'cn': '金', 'base': '#C9A24A', 'light': '#F2D48A', 'dark': '#7C5C1E'},
    'wood':  {'cn': '木', 'base': '#4E9B57', 'light': '#8FD08A', 'dark': '#2E5F3A'},
    'water': {'cn': '水', 'base': '#3C8FC9', 'light': '#8FD8F2', 'dark': '#1F4C74'},
    'fire':  {'cn': '火', 'base': '#E05A32', 'light': '#FFA45C', 'dark': '#8C2A1C'},
    'earth': {'cn': '土', 'base': '#A47C4E', 'light': '#D9B98A', 'dark': '#6B4A2E'},
}
ELEMENT_ORDER = ('metal', 'wood', 'water', 'fire', 'earth')

MOLD_BODY = (0x3A, 0x40, 0x48, 0xFF)
MOLD_RIM = (0x5C, 0x71, 0x80, 0xFF)
MOLD_RECESS = (0x1B, 0x20, 0x26, 0xFF)
PAPER = (0xE8, 0xDF, 0xC8, 0xFF)
INK = (0x2B, 0x2B, 0x2B, 0xFF)


# ---------------------------------------------------------------- 色值工具

def hx(value, alpha=255):
    """'#RRGGBB' / '#RRGGBBAA' -> (r, g, b, a)。"""
    s = value.strip().lstrip('#')
    if len(s) == 3:
        s = ''.join(ch * 2 for ch in s)
    if len(s) == 6:
        r, g, b = int(s[0:2], 16), int(s[2:4], 16), int(s[4:6], 16)
        return (r, g, b, alpha)
    if len(s) == 8:
        return (int(s[0:2], 16), int(s[2:4], 16), int(s[4:6], 16), int(s[6:8], 16))
    raise ValueError('bad color: %r' % value)


def to_hex(c):
    return '#%02X%02X%02X' % (c[0], c[1], c[2])


def mix(c1, c2, t):
    return tuple(int(round(c1[i] + (c2[i] - c1[i]) * t)) for i in range(4))


def shade(c, factor=0.72):
    return mix(c, (0, 0, 0, 255), 1.0 - factor)


def tint(c, factor=0.35):
    return mix(c, (255, 255, 255, 255), factor)


def style_acc(style, index=0):
    return hx(style['accent'][index % len(style['accent'])])


def style_dark(style):
    return hx(style['accent_dark'])


def element_palette(element):
    e = ELEMENT_COLORS[element]
    return hx(e['base']), hx(e['light']), hx(e['dark'])


# ---------------------------------------------------------------- 画布

class Canvas:
    """64×64（可改）RGBA 像素画布。

    只提供整数像素绘制，不做抗锯齿；所有公开图元返回本图元覆盖的像素集合，
    方便后续只对某个部件做高光/阴影/反光裁切。
    """

    def __init__(self, width=ICON_SIZE, height=ICON_SIZE, margin=MARGIN):
        self.w = int(width)
        self.h = int(height)
        self.margin = int(margin)
        self.px = [[(0, 0, 0, 0) for _ in range(self.w)] for _ in range(self.h)]
        self.body = set()
        self._clip = None

    # ---- 基本访问 -------------------------------------------------

    def in_bounds(self, x, y):
        return 0 <= x < self.w and 0 <= y < self.h

    def put(self, x, y, color, body=True, respect_margin=True):
        x, y = int(x), int(y)
        if body and respect_margin:
            lo, hi_x, hi_y = self.margin + 1, self.w - self.margin - 2, self.h - self.margin - 2
            if not (lo <= x <= hi_x and lo <= y <= hi_y):
                return False
        elif respect_margin:
            if not (self.margin <= x <= self.w - self.margin - 1 and
                    self.margin <= y <= self.h - self.margin - 1):
                return False
        if not self.in_bounds(x, y):
            return False
        if self._clip is not None and (x, y) not in self._clip:
            return False
        self.px[y][x] = tuple(color)
        if body:
            self.body.add((x, y))
        return True

    def get(self, x, y):
        if not self.in_bounds(x, y):
            return (0, 0, 0, 0)
        return self.px[y][x]

    def paint_mask(self, mask, color):
        for x, y in mask:
            self.put(x, y, color)
        return set(mask)

    @contextmanager
    def clipped(self, mask):
        old = self._clip
        self._clip = set(mask)
        try:
            yield self
        finally:
            self._clip = old

    # ---- 图元 -----------------------------------------------------

    def rect(self, x0, y0, x1, y1, color, fill=True):
        x0, y0, x1, y1 = sorted((int(x0), int(x1)))[0], sorted((int(y0), int(y1)))[0], \
                         sorted((int(x0), int(x1)))[1], sorted((int(y0), int(y1)))[1]
        out = set()
        if fill:
            for y in range(y0, y1 + 1):
                for x in range(x0, x1 + 1):
                    if self.put(x, y, color):
                        out.add((x, y))
        else:
            for x in range(x0, x1 + 1):
                if self.put(x, y0, color):
                    out.add((x, y0))
                if self.put(x, y1, color):
                    out.add((x, y1))
            for y in range(y0, y1 + 1):
                if self.put(x0, y, color):
                    out.add((x0, y))
                if self.put(x1, y, color):
                    out.add((x1, y))
        return out

    def line(self, x0, y0, x1, y1, color, width=1):
        x0, y0, x1, y1 = int(round(x0)), int(round(y0)), int(round(x1)), int(round(y1))
        pts = _bresenham(x0, y0, x1, y1)
        out = set()
        if width <= 1:
            for x, y in pts:
                if self.put(x, y, color):
                    out.add((x, y))
            return out
        r = (width - 1) / 2.0
        rr = r * r
        stamp = []
        for dy in range(-int(math.ceil(r)), int(math.ceil(r)) + 1):
            for dx in range(-int(math.ceil(r)), int(math.ceil(r)) + 1):
                if dx * dx + dy * dy <= rr + 0.25:
                    stamp.append((dx, dy))
        for x, y in pts:
            for dx, dy in stamp:
                if self.put(x + dx, y + dy, color):
                    out.add((x + dx, y + dy))
        return out

    def polyline(self, points, color, width=1):
        out = set()
        for i in range(len(points) - 1):
            out |= self.line(points[i][0], points[i][1], points[i + 1][0], points[i + 1][1],
                             color, width)
        return out

    def poly(self, points, color):
        pts = [(float(x), float(y)) for x, y in points]
        if len(pts) < 3:
            return set()
        out = set()
        ys = [p[1] for p in pts]
        y_min, y_max = int(math.floor(min(ys))), int(math.ceil(max(ys)))
        for y in range(y_min, y_max + 1):
            yc = y + 0.5
            xs = []
            for i in range(len(pts)):
                x0, y0 = pts[i]
                x1, y1 = pts[(i + 1) % len(pts)]
                if y0 == y1:
                    continue
                if (y0 <= yc < y1) or (y1 <= yc < y0):
                    t = (yc - y0) / (y1 - y0)
                    xs.append(x0 + t * (x1 - x0))
            xs.sort()
            for i in range(0, len(xs) - 1, 2):
                x_from = int(math.ceil(xs[i] - 0.5))
                x_to = int(math.floor(xs[i + 1] - 0.5))
                for x in range(x_from, x_to + 1):
                    if self.put(x, y, color):
                        out.add((x, y))
        # 补边，避免扫描线在尖角漏像素
        for i in range(len(pts)):
            x0, y0 = pts[i]
            x1, y1 = pts[(i + 1) % len(pts)]
            out |= self.line(x0, y0, x1, y1, color, 1)
        return out

    def circle_mask(self, cx, cy, r):
        out = set()
        cx, cy = float(cx), float(cy)
        for y in range(int(math.floor(cy - r)), int(math.ceil(cy + r)) + 1):
            for x in range(int(math.floor(cx - r)), int(math.ceil(cx + r)) + 1):
                if (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 <= r * r:
                    out.add((x, y))
        return out

    def circle(self, cx, cy, r, color, fill=True):
        outer = self.circle_mask(cx, cy, r)
        if fill:
            mask = outer
        else:
            inner = self.circle_mask(cx, cy, max(0.0, r - 1.0))
            mask = outer - inner
        return self.paint_mask(mask, color)

    def ellipse_mask(self, cx, cy, rx, ry):
        out = set()
        cx, cy = float(cx), float(cy)
        for y in range(int(math.floor(cy - ry)), int(math.ceil(cy + ry)) + 1):
            for x in range(int(math.floor(cx - rx)), int(math.ceil(cx + rx)) + 1):
                if ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2 <= 1.0:
                    out.add((x, y))
        return out

    def ellipse(self, cx, cy, rx, ry, color, fill=True):
        outer = self.ellipse_mask(cx, cy, rx, ry)
        if fill:
            mask = outer
        else:
            inner = self.ellipse_mask(cx, cy, max(0.5, rx - 1), max(0.5, ry - 1))
            mask = outer - inner
        return self.paint_mask(mask, color)

    def arc(self, cx, cy, r, a0_deg, a1_deg, color):
        span = abs(a1_deg - a0_deg)
        steps = max(8, int(span * r / 40.0 * 2))
        out = set()
        for i in range(steps + 1):
            a = math.radians(a0_deg + (a1_deg - a0_deg) * i / steps)
            x = cx + math.cos(a) * r
            y = cy + math.sin(a) * r
            if self.put(round(x), round(y), color):
                out.add((int(round(x)), int(round(y))))
        return out

    # ---- 效果 -----------------------------------------------------

    def edge_shade(self, mask, color, directions=((1, 0), (0, 1))):
        """右下阴影：把 mask 中朝右下贴边的像素压暗一层。"""
        out = set()
        for x, y in list(mask):
            for dx, dy in directions:
                if (x + dx, y + dy) not in mask:
                    if self.put(x, y, color):
                        out.add((x, y))
                    break
        return out

    def edge_highlight(self, mask, color, directions=((-1, 0), (0, -1))):
        """左上高光：把 mask 中朝左上贴边的像素提亮一层。"""
        out = set()
        for x, y in list(mask):
            for dx, dy in directions:
                if (x + dx, y + dy) not in mask:
                    if self.put(x, y, color):
                        out.add((x, y))
                    break
        return out

    def glint_line(self, x0, y0, x1, y1, color, mask=None):
        """在 mask 内画 1px 斜向反光（镜面反光只允许落在主体上）。"""
        out = set()
        for x, y in _bresenham(int(round(x0)), int(round(y0)), int(round(x1)), int(round(y1))):
            if mask is not None and (x, y) not in mask:
                continue
            if self.put(x, y, color):
                out.add((x, y))
        return out

    def crack(self, x0, y0, x1, y1, color, segments=4, jitter=2.0, seed=0, mask=None):
        """确定性折线裂纹，1px。"""
        rnd = random.Random(seed)
        dx, dy = x1 - x0, y1 - y0
        length = math.hypot(dx, dy) or 1.0
        px, py = -dy / length, dx / length
        pts = [(x0, y0)]
        for i in range(1, segments):
            t = i / float(segments)
            off = rnd.uniform(-jitter, jitter)
            pts.append((x0 + dx * t + px * off, y0 + dy * t + py * off))
        pts.append((x1, y1))
        out = set()
        for i in range(len(pts) - 1):
            xa, ya = pts[i]
            xb, yb = pts[i + 1]
            for x, y in _bresenham(int(round(xa)), int(round(ya)), int(round(xb)), int(round(yb))):
                if mask is not None and (x, y) not in mask:
                    continue
                if self.put(x, y, color):
                    out.add((x, y))
        return out

    def outline(self, color=OUTLINE):
        """在主体外沿补 1px 描边；描边只允许落在 [1, 62]，最外圈保持透明。"""
        add = set()
        for x, y in self.body:
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    if dx == 0 and dy == 0:
                        continue
                    nx, ny = x + dx, y + dy
                    if self.in_bounds(nx, ny) and self.px[ny][nx][3] == 0:
                        add.add((nx, ny))
        for x, y in add:
            self.put(x, y, color, body=False, respect_margin=True)
        return add

    # ---- 输出与自检 -----------------------------------------------

    def colors(self):
        seen = {}
        for row in self.px:
            for c in row:
                if c[3] > 0:
                    seen[c] = seen.get(c, 0) + 1
        return seen

    def alpha_mask(self):
        return {(x, y) for y in range(self.h) for x in range(self.w) if self.px[y][x][3] > 0}

    def bbox(self):
        m = self.alpha_mask()
        if not m:
            return None
        xs = [p[0] for p in m]
        ys = [p[1] for p in m]
        return min(xs), min(ys), max(xs), max(ys)

    def enforce_color_limit(self, limit=MAX_COLORS, keep=None):
        """把用色压到 limit：保留描边与高频色，其余映射到最近色。"""
        keep = set(keep or ()) | {OUTLINE}
        while True:
            counts = self.colors()
            if len(counts) <= limit:
                break
            protected = set(c for c in keep if c in counts)
            candidates = [(n, c) for c, n in counts.items() if c not in protected]
            if not candidates:
                break
            _, drop = min(candidates)
            others = [c for c in counts if c != drop]
            target = min(others, key=lambda c: sum((c[i] - drop[i]) ** 2 for i in range(3)))
            for y in range(self.h):
                for x in range(self.w):
                    if self.px[y][x] == drop:
                        self.px[y][x] = target
        return self.colors()

    def audit(self, max_colors=MAX_COLORS):
        errors = []
        warnings = []
        if (self.w, self.h) != (ICON_SIZE, ICON_SIZE):
            errors.append('尺寸必须是 %d×%d，实际 %d×%d' % (ICON_SIZE, ICON_SIZE, self.w, self.h))
        # alpha 二值
        bad_alpha = [(x, y) for y in range(self.h) for x in range(self.w)
                     if self.px[y][x][3] not in (0, 255)]
        if bad_alpha:
            errors.append('存在半透明像素 %d 个（首个 %r）' % (len(bad_alpha), bad_alpha[0]))
        # 最外圈透明
        border_bad = [(x, y) for y in range(self.h) for x in range(self.w)
                      if (x in (0, self.w - 1) or y in (0, self.h - 1)) and self.px[y][x][3] != 0]
        if border_bad:
            errors.append('最外圈必须透明，越界像素 %d 个（首个 %r）' % (len(border_bad), border_bad[0]))
        # 主体边距
        body = set(self.body)
        if not body:
            errors.append('画布为空')
        else:
            xs = [p[0] for p in body]
            ys = [p[1] for p in body]
            if min(xs) < BODY_INSET or min(ys) < BODY_INSET or \
               max(xs) > self.w - BODY_INSET - 1 or max(ys) > self.h - BODY_INSET - 1:
                errors.append('主体越界：bbox=(%d,%d,%d,%d)，要求 [%d,%d]' %
                              (min(xs), min(ys), max(xs), max(ys), BODY_INSET,
                               self.w - BODY_INSET - 1))
        # 颜色数
        counts = self.colors()
        if len(counts) > max_colors:
            errors.append('用色 %d 超过 %d' % (len(counts), max_colors))
        # 描边：凡四邻接透明的实心像素必须是描边色
        bad_outline = []
        for y in range(self.h):
            for x in range(self.w):
                c = self.px[y][x]
                if c[3] == 0:
                    continue
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < self.w and 0 <= ny < self.h and self.px[ny][nx][3] == 0:
                        if c[:3] != OUTLINE[:3]:
                            bad_outline.append((x, y))
                        break
        if bad_outline:
            errors.append('外沿缺少 #14181D 描边像素 %d 个（首个 %r）' %
                          (len(bad_outline), bad_outline[0]))
        # 覆盖率只作提示
        opaque = sum(counts.values())
        ratio = opaque / float(self.w * self.h)
        if ratio < 0.10:
            warnings.append('主体覆盖率偏低 %.1f%%，缩到 16×16 可能过细' % (ratio * 100))
        if ratio > 0.72:
            warnings.append('主体覆盖率偏高 %.1f%%，可能糊成一团' % (ratio * 100))
        return {
            'ok': not errors,
            'errors': errors,
            'warnings': warnings,
            'size': (self.w, self.h),
            'colors': len(counts),
            'opaque_pixels': opaque,
            'coverage': round(ratio, 4),
            'bbox': self.bbox(),
        }

    def save(self, path):
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        raw = bytearray()
        for row in self.px:
            for c in row:
                raw.extend(c)
        im = Image.frombytes('RGBA', (self.w, self.h), bytes(raw))
        im.save(path)
        return path

    def to_image(self):
        raw = bytearray()
        for row in self.px:
            for c in row:
                raw.extend(c)
        return Image.frombytes('RGBA', (self.w, self.h), bytes(raw))

    def downsample(self, factor=4):
        """最近邻缩小，用于 16×16 预览（不做任何平滑）。"""
        return self.to_image().resize((self.w // factor, self.h // factor), Image.NEAREST)


# ---------------------------------------------------------------- 低层辅助

def _bresenham(x0, y0, x1, y1):
    pts = []
    dx = abs(x1 - x0)
    dy = -abs(y1 - y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx + dy
    while True:
        pts.append((x0, y0))
        if x0 == x1 and y0 == y1:
            break
        e2 = 2 * err
        if e2 >= dy:
            err += dy
            x0 += sx
        if e2 <= dx:
            err += dx
            y0 += sy
    return pts


def disc_mask(cx, cy, r):
    out = set()
    for y in range(int(math.floor(cy - r)), int(math.ceil(cy + r)) + 1):
        for x in range(int(math.floor(cx - r)), int(math.ceil(cx + r)) + 1):
            if (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 <= r * r:
                out.add((x, y))
    return out


def annulus_sector_mask(cx, cy, r_in, r_out, a0_deg, a1_deg):
    out = set()
    for y in range(int(math.floor(cy - r_out)), int(math.ceil(cy + r_out)) + 1):
        for x in range(int(math.floor(cx - r_out)), int(math.ceil(cx + r_out)) + 1):
            dx, dy = x + 0.5 - cx, y + 0.5 - cy
            dist = math.hypot(dx, dy)
            if not (r_in <= dist <= r_out):
                continue
            ang = math.degrees(math.atan2(dy, dx)) % 360.0
            if a0_deg <= a1_deg:
                inside = a0_deg <= ang <= a1_deg
            else:
                inside = ang >= a0_deg or ang <= a1_deg
            if inside:
                out.add((x, y))
    return out


def bezier(p0, p1, p2, steps=32):
    pts = []
    for i in range(steps + 1):
        t = i / float(steps)
        x = (1 - t) ** 2 * p0[0] + 2 * (1 - t) * t * p1[0] + t * t * p2[0]
        y = (1 - t) ** 2 * p0[1] + 2 * (1 - t) * t * p1[1] + t * t * p2[1]
        pts.append((x, y))
    return pts


def _finish(c, shade_mask=None, highlight_mask=None, outline=True):
    if shade_mask:
        c.edge_shade(shade_mask, MIRROR[3])
    if highlight_mask:
        c.edge_highlight(highlight_mask, MIRROR[0])
    if outline:
        c.outline()
    c.enforce_color_limit(MAX_COLORS)
    return c


# ---------------------------------------------------------------- 纹样

def petal_flower(c, cx, cy, r, petal_color, center_color, petals=5):
    for i in range(petals):
        a = -math.pi / 2 + 2 * math.pi * i / petals
        px = cx + math.cos(a) * r * 0.56
        py = cy + math.sin(a) * r * 0.56
        c.circle(px, py, r * 0.44, petal_color)
    return c.circle(cx, cy, max(1.0, r * 0.30), center_color)


def motif_badge(c, cx, cy, r, style):
    """六套共用纹样。防具四件必须在固定位置调用同一个 pattern，保证同套同纹。"""
    a0 = style_acc(style, 0)
    a1 = style_acc(style, 1)
    dark = style_dark(style)
    pattern = style['pattern']
    r = float(r)

    if pattern == 'rings':            # 照心：圆镜盘 + 同心波纹
        c.circle(cx, cy, r, a0)
        c.circle(cx, cy, r - 1, MIRROR[1])
        c.circle(cx, cy, max(1.0, r - 2), a1, fill=False)
        c.circle(cx, cy, max(1.0, r - 4), MIRROR[4])
        c.put(cx, cy, MIRROR[0])
    elif pattern == 'crack':          # 裂影：斜向折线裂痕 + 碎片
        c.circle(cx, cy, r, MIRROR[2])
        c.crack(cx - r + 2, cy - r + 1, cx + r - 2, cy + r - 1, a0,
                segments=3, jitter=2.0, seed=7)
        c.line(cx - r + 2, cy - r + 1, cx - 1, cy + 1, a1, 1)
        c.poly([(cx + r - 3, cy - r + 2), (cx + r, cy - r + 5),
                (cx + r - 5, cy - r + 6)], a1)
        c.poly([(cx - r + 1, cy + r - 5), (cx - r + 5, cy + r - 2),
                (cx - r + 2, cy + r)], a0)
    elif pattern == 'flower':         # 镜花：五瓣花 + 水月弧
        petal_flower(c, cx, cy - 1, r, a0, a1, 5)
        c.arc(cx, cy + 2, r - 1, 20, 160, a1)
        c.arc(cx, cy + 3, r - 3, 20, 160, MIRROR[0])
    elif pattern == 'ghost':          # 残影：偏移双轮廓 + 速度线
        c.circle(cx - 1, cy - 1, r - 1, a1, fill=False)
        c.circle(cx + 1, cy + 1, r, a0, fill=False)
        c.line(cx - r - 2, cy + r, cx - r + 3, cy + r, a1, 1)
        c.line(cx - r - 3, cy + r - 3, cx - r + 1, cy + r - 3, a0, 1)
        c.put(cx + 1, cy + 1, MIRROR[0])
    elif pattern == 'twin':           # 双生：左右对称双半 + 双圆
        gold, blue = a0, a1
        m = c.circle_mask(cx, cy, r)
        c.paint_mask({p for p in m if p[0] < cx}, gold)
        c.paint_mask({p for p in m if p[0] >= cx}, blue)
        c.line(cx - 1, cy - r + 1, cx - 1, cy + r - 1, MIRROR[0], 1)
        c.circle(cx - r * 0.45, cy, max(1.0, r * 0.22), tint(gold, 0.5))
        c.circle(cx + r * 0.45, cy, max(1.0, r * 0.22), tint(blue, 0.5))
    elif pattern == 'stamp':          # 拓印：方形印章 + 纸纹
        paper = hx(style.get('paper', '#E8DFC8'))
        c.rect(cx - r, cy - r, cx + r, cy + r, a0, fill=True)
        c.rect(cx - r + 1, cy - r + 1, cx + r - 1, cy + r - 1, paper, fill=True)
        for i in range(3):
            y = cy - r + 3 + i * 3
            c.line(cx - r + 3, y, cx + r - 3, y, dark if i % 2 else a1, 1)
        c.line(cx, cy - r + 3, cx, cy + r - 3, dark, 1)
    return c


# ---------------------------------------------------------------- 武器

def draw_sword(style):
    """照心镜剑：直刃 + 圆镜剑格（圆镜盘纹样落在剑格上）。"""
    c = Canvas()
    G = (23.0, 44.0)
    T = (57.0, 8.0)
    P = (6.0, 58.0)
    perp = (0.719, 0.695)
    hw = 6.2
    B1 = (G[0] + perp[0] * hw, G[1] + perp[1] * hw)   # 右下剑根
    B2 = (G[0] - perp[0] * hw, G[1] - perp[1] * hw)   # 左上剑根
    ux0, uy0 = (T[0] - G[0]), (T[1] - G[1])
    ln = math.hypot(ux0, uy0)
    ux0, uy0 = ux0 / ln, uy0 / ln
    shoulder = (G[0] + ux0 * 38, G[1] + uy0 * 38)
    sh_hw = 4.3
    S1 = (shoulder[0] + perp[0] * sh_hw, shoulder[1] + perp[1] * sh_hw)
    S2 = (shoulder[0] - perp[0] * sh_hw, shoulder[1] - perp[1] * sh_hw)

    blade = c.poly([T, S1, B1, B2, S2], MIRROR[1])
    # 右下侧压暗，保留左上受光面
    c.poly([T, S1, B1, G, S2], MIRROR[2])
    # 中脊 1px 反光
    ux, uy = 0.697, -0.717
    c.line(G[0] + ux * 3, G[1] + uy * 3, T[0] - ux * 4, T[1] - uy * 4, MIRROR[0], 1)
    # 第二条斜向反光：横切剑身（全图共 2 条：中脊 1 + 横切 1）
    with c.clipped(blade):
        c.line(36, 22, 44, 30, MIRROR[0], 1)

    # 剑柄
    c.line(G[0], G[1], P[0], P[1], MIRROR[4], 5)
    c.line(G[0] - 1, G[1] - 1, P[0] - 1, P[1] - 1, MIRROR[3], 1)
    dx, dy = P[0] - G[0], P[1] - G[1]
    L = math.hypot(dx, dy)
    ux2, uy2 = dx / L, dy / L
    px2, py2 = -uy2, ux2
    for t in (0.30, 0.55, 0.80):
        cx = G[0] + dx * t
        cy = G[1] + dy * t
        c.line(cx - px2 * 2.8, cy - py2 * 2.8, cx + px2 * 2.8, cy + py2 * 2.8,
               style_acc(style, 0), 1)
    # 剑首
    c.circle(P[0], P[1], 3.2, style_acc(style, 0))
    c.circle(P[0], P[1], 2.2, MIRROR[1])
    c.circle(P[0], P[1], 1.0, MIRROR[0])

    # 圆镜剑格：圆镜盘 + 同心波纹
    guard = c.circle(G[0], G[1], 8.5, MIRROR[2])
    c.circle(G[0] - 1, G[1] - 1, 8.0, MIRROR[1])
    c.circle(G[0], G[1], 6.2, style_acc(style, 0), fill=False)
    c.circle(G[0], G[1], 5.0, MIRROR[1])
    c.circle(G[0], G[1], 3.4, style_acc(style, 0), fill=False)
    c.circle(G[0], G[1], 2.4, MIRROR[0])
    c.put(G[0] - 3, G[1] - 3, MIRROR[0])
    c.put(G[0] - 2, G[1] - 3, MIRROR[0])
    c.put(G[0] - 3, G[1] - 2, style_acc(style, 1))

    _finish(c, shade_mask=blade | guard, highlight_mask=blade)
    return c


def draw_axe(style):
    """裂影镜斧：新月刃 + 镜核，刃上折线裂痕与碎片刻意偏出剪影。"""
    c = Canvas()
    shaft_end = (46.0, 20.0)
    butt = (10.0, 56.0)
    c.line(butt[0], butt[1], shaft_end[0], shaft_end[1], MIRROR[4], 4)
    c.line(butt[0] - 1, butt[1] - 1, shaft_end[0] - 1, shaft_end[1] - 1, MIRROR[3], 1)
    # 握把缠带
    sx, sy = shaft_end[0] - butt[0], shaft_end[1] - butt[1]
    L = math.hypot(sx, sy)
    ux, uy = sx / L, sy / L
    px, py = -uy, ux
    for t in (0.24, 0.46, 0.68):
        cx, cy = butt[0] + sx * t, butt[1] + sy * t
        c.line(cx - px * 2.4, cy - py * 2.4, cx + px * 2.4, cy + py * 2.4,
               style_acc(style, 0), 1)
    # 新月刃：大圆减小圆
    outer = disc_mask(46, 18, 15.5)
    inner = disc_mask(56, 8, 14.5)
    head = outer - inner
    c.paint_mask(head, MIRROR[2])
    c.edge_highlight(head, MIRROR[1])
    # 刃上裂痕
    c.crack(38, 24, 50, 12, style_acc(style, 0), segments=3, jitter=1.6, seed=3, mask=head)
    c.crack(42, 30, 52, 22, style_acc(style, 1), segments=2, jitter=1.2, seed=8, mask=head)
    # 碎片刻意离开刃口（仍是主体的一部分，保证描边后可读）
    c.poly([(55, 29), (60, 33), (56, 37)], style_acc(style, 0))
    c.poly([(36, 4), (42, 2), (41, 8)], style_acc(style, 1))
    # 镜核
    c.circle(42, 27, 6.2, style_acc(style, 0))
    c.circle(42, 27, 4.8, MIRROR[4])
    c.circle(42, 27, 2.6, MIRROR[1])
    c.put(40, 25, MIRROR[0])
    c.put(41, 25, MIRROR[0])
    _finish(c, shade_mask=head, highlight_mask=None)
    return c


def draw_bow(style, state='static'):
    """镜花境弓：反曲臂 + 花瓣臂端 + 1px 弦。pulling 三态拉弦深度递增。"""
    c = Canvas()
    S, E, C = (12.0, 54.0), (52.0, 12.0), (16.0, 12.0)
    curve = bezier(S, C, E, 34)
    body = c.polyline(curve, MIRROR[2], 4)
    # 弓臂内侧受光
    inner = [(x - 1.0, y - 1.0) for x, y in curve]
    c.polyline(inner, MIRROR[1], 1)
    # 臂端花瓣（镜花纹样）
    for (tx, ty) in (S, E):
        petal_flower(c, tx, ty, 5.0, style_acc(style, 0), style_acc(style, 1), 5)
        c.put(int(tx), int(ty), style_acc(style, 0))
    # 弦
    d = {'static': 0.0, 'pulling_0': 3.5, 'pulling_1': 8.0, 'pulling_2': 12.5}.get(state, 0.0)
    mx, my = (S[0] + E[0]) / 2.0, (S[1] + E[1]) / 2.0
    nx, ny = -(E[1] - S[1]), (E[0] - S[0])
    nl = math.hypot(nx, ny)
    nx, ny = nx / nl, ny / nl
    vx, vy = mx + nx * d, my + ny * d
    c.line(S[0], S[1], vx, vy, MIRROR[0], 1)
    c.line(vx, vy, E[0], E[1], MIRROR[0], 1)
    # 搭箭（仅拉弓态）
    if d > 0:
        ax, ay = (E[0] - S[0]) / nl, (E[1] - S[1]) / nl
        c.line(vx - ax * 5, vy - ay * 5, vx + ax * 13, vy + ay * 13, style_dark(style), 1)
        hx0, hy0 = vx + ax * 13, vy + ay * 13
        c.poly([(hx0 + ax * 3, hy0 + ay * 3),
                (hx0 - ay * 2, hy0 + ax * 2),
                (hx0 + ay * 2, hy0 - ax * 2)], style_acc(style, 1))
        c.line(vx - ax * 5, vy - ay * 5, vx - ax * 2 - ay * 2, vy - ay * 2 + ax * 2,
               style_acc(style, 0), 1)
    # 握把
    gx, gy = curve[len(curve) // 2]
    c.circle(gx, gy, 4.0, MIRROR[4])
    c.circle(gx, gy, 3.0, style_acc(style, 0), fill=False)
    c.put(int(gx) - 1, int(gy) - 1, MIRROR[0])
    _finish(c, shade_mask=body, highlight_mask=None)
    return c


def draw_crossbow(style, state='static'):
    """残影镜弩：弩身 + 双弓臂 + 镜弩机 + 残影副轮廓；六态。"""
    c = Canvas()
    butt, nose = (14.0, 50.0), (46.0, 20.0)
    ux, uy = 0.72, -0.694
    px, py = -uy, ux

    # 残影副轮廓 / 速度线（先画，主体压在上面）
    c.line(butt[0] + 3, butt[1] + 3, nose[0] + 3, nose[1] + 3, style_acc(style, 1), 1)
    for off in (4, 7):
        c.line(butt[0] - off, butt[1] + 1, butt[0] - off + 6 * ux, butt[1] + 1 + 6 * uy,
               style_acc(style, 1), 1)

    # 弩身
    c.line(butt[0], butt[1], nose[0], nose[1], MIRROR[4], 5)
    c.line(butt[0] - 1, butt[1] - 1, nose[0] - 1, nose[1] - 1, MIRROR[3], 1)

    # 弓臂端点（垂直于弩身）
    arm_a = (nose[0] + px * 15, nose[1] + py * 15)
    arm_b = (nose[0] - px * 15, nose[1] - py * 15)

    # 残影副臂：与上侧弓臂平行、偏移 4px，1px 青色
    c.line(arm_b[0] + 4, arm_b[1] + 4, nose[0] + 4, nose[1] + 4, style_acc(style, 1), 1)

    # 弦：先画弦，再画弓臂，让弦从臂后穿过
    d = {'static': 0.0, 'pulling_0': 4.0, 'pulling_1': 8.5, 'pulling_2': 12.0}.get(state, 0.0)
    if state in ('arrow', 'firework'):
        d = 0.0
    vx, vy = nose[0] - ux * d, nose[1] - uy * d
    c.line(arm_b[0], arm_b[1], vx, vy, MIRROR[0], 1)
    c.line(vx, vy, arm_a[0], arm_a[1], MIRROR[0], 1)

    # 弓臂：向前（朝目标）微拱，使弦与臂之间留出可读的缝
    mid_b = ((arm_b[0] + nose[0]) / 2 + ux * 6.0, (arm_b[1] + nose[1]) / 2 + uy * 6.0)
    mid_a = ((arm_a[0] + nose[0]) / 2 + ux * 6.0, (arm_a[1] + nose[1]) / 2 + uy * 6.0)
    arm = c.polyline([arm_b, mid_b, nose, mid_a, arm_a], MIRROR[2], 3)
    c.line(arm_b[0] - 1, arm_b[1] - 1, mid_b[0] - 1, mid_b[1] - 1, MIRROR[1], 1)
    c.line(mid_a[0] - 1, mid_a[1] - 1, arm_a[0] - 1, arm_a[1] - 1, MIRROR[1], 1)
    # 臂端回勾
    c.line(arm_a[0], arm_a[1], arm_a[0] + 5, arm_a[1] - 2, style_acc(style, 0), 2)
    c.line(arm_b[0], arm_b[1], arm_b[0] - 5, arm_b[1] + 2, style_acc(style, 0), 2)

    # 镜弩机
    c.circle(34, 31, 6.0, style_acc(style, 0))
    c.circle(34, 31, 4.6, MIRROR[4])
    c.circle(34, 31, 2.4, MIRROR[1])
    c.put(32, 29, MIRROR[0])

    # 箭 / 烟花
    if state in ('arrow', 'firework'):
        tip = (52.0, 15.0)
        c.line(nose[0] - ux * 10, nose[1] - uy * 10, tip[0], tip[1], MIRROR[1], 2)
        c.poly([(tip[0] + 4, tip[1] - 3), (tip[0] - 1, tip[1] - 3), (tip[0] - 1, tip[1] + 3)],
               MIRROR[0] if state == 'arrow' else style_acc(style, 0))
        if state == 'firework':
            for (fx, fy) in ((55, 10), (57, 13), (53, 8), (58, 8)):
                c.line(fx - 2, fy, fx + 2, fy, style_acc(style, 1), 1)
                c.line(fx, fy - 2, fx, fy + 2, style_acc(style, 1), 1)
        else:
            for i in range(2):
                c.line(nose[0] - ux * (6 + i * 2) - px * 2, nose[1] - uy * (6 + i * 2) - py * 2,
                       nose[0] - ux * (6 + i * 2) + px * 2, nose[1] - uy * (6 + i * 2) + py * 2,
                       style_acc(style, 1), 1)
    elif d > 0:
        c.line(vx - ux * 4, vy - uy * 4, vx + ux * 9, vy + uy * 9, MIRROR[1], 1)

    _finish(c, shade_mask=arm, highlight_mask=None)
    return c


def draw_twin_furnace(style):
    """双生镜炉：杖形 + 两个对称镜球（左金右蓝）。"""
    c = Canvas()
    # 杖
    c.line(32, 58, 32, 30, MIRROR[4], 5)
    c.line(31, 58, 31, 30, MIRROR[3], 1)
    for y in (46, 52):
        c.line(28, y, 36, y, style_acc(style, 0), 1)
    c.circle(32, 58, 3.5, style_acc(style, 0))
    c.circle(32, 58, 2.2, MIRROR[1])
    # 横梁
    bar = c.line(13, 22, 51, 22, MIRROR[2], 3)
    c.line(13, 21, 51, 21, MIRROR[1], 1)
    c.circle(13, 20, 2.0, style_acc(style, 0))
    c.circle(51, 20, 2.0, style_acc(style, 1))
    # 两个镜球
    c.circle(16, 14, 7.5, style_acc(style, 0))
    c.circle(15, 13, 6.2, tint(style_acc(style, 0), 0.35))
    c.circle(16, 14, 4.8, MIRROR[1])
    c.put(14, 12, MIRROR[0])
    c.put(15, 12, MIRROR[0])
    c.circle(48, 14, 7.5, style_acc(style, 1))
    c.circle(47, 13, 6.2, tint(style_acc(style, 1), 0.35))
    c.circle(48, 14, 4.8, MIRROR[1])
    c.put(46, 12, MIRROR[0])
    c.put(47, 12, MIRROR[0])
    # 中央镜菱（左右对称双半）
    m = c.poly([(32, 9), (40, 18), (32, 27), (24, 18)], MIRROR[2])
    c.poly([(32, 9), (40, 18), (32, 27)], MIRROR[1])
    c.line(32, 9, 32, 27, style_acc(style, 0), 1)
    c.put(31, 17, MIRROR[0])
    c.put(32, 16, style_acc(style, 1))
    _finish(c, shade_mask=bar, highlight_mask=None)
    return c


def draw_rub_furnace(style):
    """拓印镜炉：铲形 + 纸符/印章板，底部撕裂，朱砂印章。"""
    c = Canvas()
    paper = hx(style.get('paper', '#E8DFC8'))
    # 柄（先画，纸板压住顶部）
    c.line(32, 58, 32, 34, MIRROR[4], 5)
    c.line(31, 58, 31, 34, MIRROR[3], 1)
    for y in (46, 52):
        c.line(28, y, 36, y, style_acc(style, 0), 1)
    c.circle(32, 58, 3.5, style_acc(style, 0))
    c.circle(32, 58, 2.2, MIRROR[1])
    # 纸符板：方形铲面 + 底部撕裂
    pts = [(14, 10), (50, 10), (50, 38),
           (47, 43), (44, 38), (41, 43), (38, 38), (35, 43),
           (32, 38), (29, 43), (26, 38), (23, 43), (20, 38), (17, 43), (14, 38)]
    board = c.poly(pts, paper)
    # 纸边与阴影
    c.line(14, 10, 50, 10, hx('#C9BFA6'), 1)
    c.line(14, 10, 14, 38, hx('#C9BFA6'), 1)
    c.line(50, 10, 50, 38, hx('#A89E86'), 1)
    # 纸纹：短横线
    for y in (14, 18, 30, 34):
        c.line(17, y, 25, y, hx('#D6CBB2'), 1)
        c.line(38, y, 46, y, hx('#D6CBB2'), 1)
    # 符文竖排
    ink = hx(style['accent'][1])
    for x in (20, 24, 28):
        c.line(x, 15, x, 32, ink, 1)
        for y in (17, 21, 25, 29):
            c.line(x - 1, y, x + 1, y, ink, 1)
    # 朱砂印章
    seal = c.rect(33, 24, 46, 37, style_acc(style, 0), fill=True)
    c.rect(34, 25, 45, 36, paper, fill=True)
    c.line(36, 28, 43, 28, style_acc(style, 0), 1)
    c.line(36, 31, 43, 31, style_acc(style, 0), 1)
    c.line(36, 34, 43, 34, style_acc(style, 0), 1)
    c.line(39, 27, 39, 35, style_acc(style, 0), 1)
    # 顶部挂绳孔
    c.circle(32, 12, 1.6, hx('#6B6152'))
    _finish(c, shade_mask=board, highlight_mask=None)
    return c


# ---------------------------------------------------------------- 防具

def draw_armor(style, part):
    """六套防具图标。四件共用 motif_badge，位置固定：盔额/胸心/腰带/靴踝。"""
    if part == 'helmet':
        return _armor_helmet(style)
    if part == 'chestplate':
        return _armor_chest(style)
    if part == 'leggings':
        return _armor_legs(style)
    if part == 'boots':
        return _armor_boots(style)
    raise ValueError('unknown armor part: %r' % part)


def _armor_helmet(style):
    c = Canvas()
    dome_pts = [(32 + 20 * math.cos(math.radians(a)), 30 + 23 * math.sin(math.radians(a)))
                for a in range(180, 361, 6)]
    dome_pts += [(52, 42), (12, 42)]
    dome = c.poly(dome_pts, MIRROR[2])
    # 面甲开口（实心暗部，不是透明洞）
    face = c.poly([(26, 28), (32, 24), (38, 28), (38, 45), (26, 45)], MIRROR[4])
    c.line(27, 30, 31, 27, MIRROR[3], 1)
    # 下沿与护颊
    rim = c.rect(11, 38, 53, 45, MIRROR[1])
    c.rect(9, 36, 17, 50, MIRROR[2])
    c.rect(47, 36, 55, 50, MIRROR[2])
    c.edge_shade({(x, y) for x in range(47, 56) for y in range(36, 51)}, MIRROR[3])
    # 冠饰
    crest = c.poly([(30, 4), (34, 4), (36, 22), (28, 22)], style_acc(style, 0))
    c.line(31, 5, 31, 21, style_acc(style, 1), 1)
    c.poly([(28, 22), (36, 22), (34, 27), (30, 27)], style_dark(style))
    # 额心纹样
    motif_badge(c, 32, 24, 4.5, style)
    # 颈甲
    c.rect(24, 45, 40, 49, MIRROR[2])
    c.line(25, 45, 39, 45, MIRROR[0], 1)
    _finish(c, shade_mask=dome | rim | face, highlight_mask=dome)
    return c


def _armor_chest(style):
    c = Canvas()
    pa_l = c.ellipse(14, 24, 10, 9, MIRROR[2])
    pa_r = c.ellipse(50, 24, 10, 9, MIRROR[2])
    torso = c.poly([(22, 16), (42, 16), (48, 34), (45, 46), (38, 52),
                    (26, 52), (19, 46), (16, 34)], MIRROR[1])
    # 领口
    c.ellipse(32, 16, 6, 3.2, MIRROR[4])
    c.line(23, 16, 41, 16, MIRROR[0], 1)
    # 腰甲
    waist = c.rect(22, 46, 42, 52, style_dark(style))
    c.line(23, 47, 41, 47, style_acc(style, 0), 1)
    c.rect(30, 47, 34, 51, style_acc(style, 0))
    # 侧摆
    c.poly([(16, 42), (22, 42), (22, 50), (18, 52)], MIRROR[2])
    c.poly([(42, 42), (48, 42), (46, 52), (42, 50)], MIRROR[2])
    # 胸心大纹样
    motif_badge(c, 32, 33, 7.0, style)
    # 肩甲受光
    c.line(6, 22, 20, 16, MIRROR[0], 1)
    c.line(44, 16, 58, 22, MIRROR[0], 1)
    _finish(c, shade_mask=torso | pa_l | pa_r | waist, highlight_mask=torso)
    return c


def _armor_legs(style):
    c = Canvas()
    belt = c.rect(16, 12, 48, 22, MIRROR[1])
    c.line(17, 13, 47, 13, MIRROR[0], 1)
    c.rect(18, 22, 46, 33, MIRROR[2])
    leg_l = c.poly([(18, 31), (30, 31), (29, 58), (20, 58)], MIRROR[1])
    leg_r = c.poly([(34, 31), (46, 31), (44, 58), (35, 58)], MIRROR[1])
    # 侧挂镜片
    plate_l = c.rect(8, 26, 15, 44, MIRROR[2])
    plate_r = c.rect(49, 26, 56, 44, MIRROR[2])
    c.rect(9, 27, 14, 33, MIRROR[1])
    c.rect(50, 27, 55, 33, MIRROR[1])
    c.line(10, 28, 13, 28, MIRROR[0], 1)
    c.line(51, 28, 54, 28, MIRROR[0], 1)
    # 膝甲
    c.rect(19, 41, 29, 44, style_dark(style))
    c.rect(35, 41, 45, 44, style_dark(style))
    c.line(20, 42, 28, 42, style_acc(style, 0), 1)
    c.line(36, 42, 44, 42, style_acc(style, 0), 1)
    # 腰带扣纹样
    motif_badge(c, 32, 18, 5.0, style)
    _finish(c, shade_mask=belt | leg_l | leg_r | plate_l | plate_r, highlight_mask=leg_l | leg_r)
    return c


def _armor_boots(style):
    c = Canvas()
    shaft_l = c.poly([(13, 22), (29, 22), (28, 44), (14, 44)], MIRROR[1])
    shaft_r = c.poly([(35, 22), (51, 22), (50, 44), (36, 44)], MIRROR[1])
    foot_l = c.poly([(12, 40), (30, 40), (32, 50), (30, 56), (11, 56), (10, 50)], MIRROR[2])
    foot_r = c.poly([(34, 40), (52, 40), (54, 50), (53, 56), (34, 56), (32, 50)], MIRROR[2])
    # 脚踝环
    c.rect(12, 31, 30, 35, style_dark(style))
    c.rect(34, 31, 52, 35, style_dark(style))
    c.line(13, 32, 29, 32, style_acc(style, 0), 1)
    c.line(35, 32, 51, 32, style_acc(style, 0), 1)
    # 鞋头镜片
    c.poly([(12, 48), (26, 48), (28, 55), (11, 55)], MIRROR[1])
    c.poly([(36, 48), (50, 48), (53, 55), (34, 55)], MIRROR[1])
    c.line(14, 49, 24, 49, MIRROR[0], 1)
    c.line(38, 49, 48, 49, MIRROR[0], 1)
    # 鞋底
    c.rect(11, 55, 30, 57, MIRROR[4])
    c.rect(34, 55, 53, 57, MIRROR[4])
    # 踝部纹样（左右各一次，同套同纹）
    motif_badge(c, 21, 27, 3.6, style)
    motif_badge(c, 43, 27, 3.6, style)
    _finish(c, shade_mask=shaft_l | shaft_r | foot_l | foot_r, highlight_mask=shaft_l | shaft_r)
    return c


# ---------------------------------------------------------------- 材料

def draw_material(kind, variant=None, style=None):
    """33 个材料/道具图标。"""
    if kind == 'shard':
        return _mat_shard(variant or 'metal')
    if kind == 'heart':
        return _mat_heart(variant or 'metal')
    if kind == 'mold':
        return _mat_mold(variant or 'sword')
    if kind == 'edge':
        return _mat_edge(style or SET_STYLE[variant or 'zhao'])
    if kind == 'dust':
        return _mat_dust()
    if kind == 'sand':
        return _mat_sand()
    if kind == 'seal':
        return _mat_seal(variant or 1)
    if kind == 'core':
        return _mat_core()
    raise ValueError('unknown material kind: %r' % kind)


def _mat_shard(element):
    c = Canvas()
    base, light, dark = element_palette(element)
    pts = [(34, 6), (55, 37), (40, 46), (18, 52), (24, 30)]
    shard = c.poly(pts, MIRROR[2])
    # 主受光面
    c.poly([(34, 6), (55, 37), (38, 34)], MIRROR[1])
    # 元素色芯（三角）
    core = c.poly([(34, 18), (46, 36), (28, 40)], base)
    c.poly([(34, 18), (40, 30), (31, 32)], light)
    # 断口
    c.line(40, 46, 18, 52, MIRROR[3], 1)
    c.line(34, 6, 24, 30, MIRROR[0], 1)
    # 小碎镜
    c.poly([(48, 46), (56, 52), (46, 56)], MIRROR[1])
    c.line(49, 47, 53, 51, base, 1)
    c.glint_line(31, 12, 36, 18, MIRROR[0], mask=shard)
    _finish(c, shade_mask=shard, highlight_mask=None)
    return c


def _mat_heart(element):
    c = Canvas()
    base, light, dark = element_palette(element)
    if element in ('water', 'fire'):
        outer_pts = [(32, 5), (57, 32), (32, 59), (7, 32)]   # 菱形
        inner_pts = [(32, 15), (47, 32), (32, 49), (17, 32)]
        core_pts = [(32, 22), (40, 32), (32, 42), (24, 32)]
    else:
        outer_pts = [(32, 7), (52, 19), (52, 45), (32, 57), (12, 45), (12, 19)]  # 六边
        inner_pts = [(32, 15), (46, 23), (46, 41), (32, 49), (18, 41), (18, 23)]
        core_pts = [(32, 22), (41, 27), (41, 37), (32, 42), (23, 37), (23, 27)]
    outer = c.poly(outer_pts, MIRROR[2])
    c.poly(inner_pts, base)
    c.poly(core_pts, light)
    # 刻面
    for p in outer_pts:
        c.line(32, 32, p[0], p[1], MIRROR[3], 1)
    c.line(32, 18, 32, 46, MIRROR[0], 1)
    c.put(32, 27, MIRROR[0])
    c.put(31, 28, MIRROR[0])
    _finish(c, shade_mask=outer, highlight_mask=outer)
    return c


def _mat_mold(kind):
    c = Canvas()
    block = c.poly([(14, 10), (50, 10), (54, 14), (54, 48), (50, 52), (14, 52),
                    (10, 48), (10, 14)], MOLD_BODY)
    c.line(12, 12, 52, 12, MOLD_RIM, 1)
    c.line(12, 12, 12, 50, hx('#6E8593'), 1)
    recess = c.rect(16, 16, 48, 46, MOLD_RECESS)
    # 模具缺口
    c.rect(18, 10, 22, 13, MOLD_RECESS)
    c.rect(42, 10, 46, 13, MOLD_RECESS)
    col = MIRROR[2]
    # 凹槽内的器形剪影
    if kind == 'sword':
        c.line(22, 43, 43, 21, col, 4)
        c.circle(24, 41, 3, col)
        c.line(20, 45, 24, 41, col, 2)
    elif kind == 'axe':
        c.line(22, 44, 37, 27, col, 3)
        m = disc_mask(41, 22, 8) - disc_mask(46, 17, 7)
        c.paint_mask(m, col)
    elif kind == 'bow':
        pts = bezier((22, 44), (27, 28), (44, 20), 18)
        c.polyline(pts, col, 2)
        c.line(22, 44, 44, 20, MIRROR[1], 1)
    elif kind == 'crossbow':
        c.line(22, 42, 42, 23, col, 3)
        c.line(25, 25, 45, 39, col, 2)
        c.circle(34, 32, 3, col)
    elif kind == 'furnace_twin':
        c.line(32, 44, 32, 22, col, 3)
        c.line(23, 21, 41, 21, col, 2)
        c.circle(23, 17, 3, col)
        c.circle(41, 17, 3, col)
    elif kind == 'furnace_rub':
        c.line(32, 44, 32, 28, col, 3)
        c.rect(23, 16, 41, 28, col)
        c.rect(27, 20, 37, 24, MOLD_BODY)
    elif kind == 'helmet':
        c.poly([(22, 32), (24, 22), (32, 17), (40, 22), (42, 32), (42, 38), (22, 38)], col)
        c.rect(28, 28, 36, 39, MOLD_RECESS)
    elif kind == 'chestplate':
        c.poly([(24, 20), (40, 20), (44, 30), (41, 41), (23, 41), (20, 30)], col)
        c.circle(32, 21, 3, MOLD_RECESS)
    elif kind == 'leggings':
        c.rect(22, 19, 42, 25, col)
        c.rect(23, 25, 30, 43, col)
        c.rect(34, 25, 41, 43, col)
    elif kind == 'boots':
        c.rect(22, 20, 29, 36, col)
        c.rect(35, 20, 42, 36, col)
        c.poly([(22, 34), (30, 34), (31, 42), (21, 42)], col)
        c.poly([(34, 34), (42, 34), (43, 42), (33, 42)], col)
    _finish(c, shade_mask=block | recess, highlight_mask=None)
    return c


def _mat_edge(style):
    c = Canvas()
    m = annulus_sector_mask(32, 36, 17, 27, 200, 340)
    c.paint_mask(m, MIRROR[2])
    # 内圈受光
    inner = annulus_sector_mask(32, 36, 17, 20, 200, 340)
    c.paint_mask(inner, MIRROR[1])
    # 强调色嵌条
    inlay = annulus_sector_mask(32, 36, 22.0, 23.2, 200, 340)
    c.paint_mask(inlay, style_acc(style, 0))
    # 刻度
    for a in (220, 250, 290, 320):
        rad = math.radians(a)
        x0 = 32 + math.cos(rad) * 18
        y0 = 36 + math.sin(rad) * 18
        x1 = 32 + math.cos(rad) * 26
        y1 = 36 + math.sin(rad) * 26
        c.line(x0, y0, x1, y1, MIRROR[4], 1)
    # 端头
    for a in (200, 340):
        rad = math.radians(a)
        ex, ey = 32 + math.cos(rad) * 22, 36 + math.sin(rad) * 22
        c.circle(ex, ey, 3.0, style_dark(style))
        c.circle(ex, ey, 1.5, style_acc(style, 1))
    c.glint_line(14, 30, 26, 18, MIRROR[0], mask=m)
    _finish(c, shade_mask=m, highlight_mask=None)
    return c


def _mat_dust():
    c = Canvas()
    mound = c.poly([(10, 50), (16, 38), (24, 32), (32, 34), (40, 30), (50, 36),
                    (54, 48), (50, 54), (14, 54)], hx('#6B5A7D'))
    c.edge_shade(mound, hx('#4A3D57'))
    c.edge_highlight(mound, hx('#9A87AD'))
    rnd = random.Random(12)
    for _ in range(26):
        x = rnd.randint(14, 50)
        y = rnd.randint(36, 52)
        if (x, y) in mound:
            c.put(x, y, rnd.choice([hx('#8A76A0'), hx('#C9B8DC'), hx('#4A3D57')]))
    for (x, y) in ((20, 22), (43, 18), (50, 26), (28, 12)):
        c.put(x, y, hx('#F4FBFF'))
        c.put(x - 1, y, hx('#C9B8DC'))
        c.put(x + 1, y, hx('#C9B8DC'))
        c.put(x, y - 1, hx('#C9B8DC'))
        c.put(x, y + 1, hx('#C9B8DC'))
    _finish(c, shade_mask=mound, highlight_mask=None)
    return c


def _mat_sand():
    c = Canvas()
    mound = c.poly([(10, 48), (18, 34), (28, 30), (38, 32), (48, 38), (54, 48),
                    (52, 54), (12, 54)], hx('#D8D5CC'))
    c.edge_shade(mound, hx('#A8A49A'))
    c.edge_highlight(mound, hx('#F2F0E8'))
    rnd = random.Random(7)
    for _ in range(70):
        x = rnd.randint(12, 52)
        y = rnd.randint(34, 53)
        if (x, y) in mound:
            c.put(x, y, rnd.choice([hx('#BDB9AE'), hx('#EDEAE0'), hx('#8F8B80')]))
    for (x, y) in ((22, 25), (34, 20), (44, 28)):
        c.put(x, y, hx('#FFFFFF'))
    _finish(c, shade_mask=mound, highlight_mask=None)
    return c


def _mat_seal(number):
    c = Canvas()
    rev = number == 'rev'
    paper = hx('#D8CFC0') if rev else hx('#E8DFC8')
    ink = hx('#6B3FA0') if rev else hx('#2B2B2B')
    seal_col = hx('#6B3FA0') if rev else hx('#C8483C')
    pts = [(16, 10), (48, 10), (48, 38), (45, 43), (42, 38), (39, 43), (36, 38),
           (33, 43), (30, 38), (27, 43), (24, 38), (21, 43), (18, 38), (16, 38)]
    sheet = c.poly(pts, paper)
    c.line(16, 10, 48, 10, hx('#C9BFA6'), 1)
    c.line(16, 10, 16, 38, hx('#C9BFA6'), 1)
    c.line(48, 10, 48, 38, hx('#A89E86'), 1)
    # 符文竖排
    for x in (21, 25, 29):
        c.line(x, 15, x, 31, ink, 1)
        for y in (17, 21, 25, 29):
            c.line(x - 1, y, x + 1, y, ink, 1)
    # 印章 8×10
    glyph = int(number) if not rev else 3
    seal_stamp(c, 33, 25, 45, 36, seal_col, paper, glyph, flip=rev)
    if rev:
        c.line(34, 35, 44, 26, paper, 1)
    c.circle(32, 13, 1.6, hx('#6B6152'))
    _finish(c, shade_mask=sheet, highlight_mask=None)
    return c


def _seal_glyph(c, x0, y0, w, h, n, color, flip=False):
    # 壹/贰/叁 的像素抽象：横画数 = n，中枢竖画一根
    rows = [y0 + 1 + i * max(2, (h - 2) // 3) for i in range(3)]
    for i in range(min(n, 3)):
        y = rows[2 - i] if flip else rows[i]
        c.line(x0 + 1, y, x0 + w - 2, y, color, 1)
    x = x0 + w // 2
    if flip:
        c.line(x, y0 + h - 2, x, y0 + 1, color, 1)
        c.put(x, y0 + h - 2, color)
    else:
        c.line(x, y0 + 1, x, y0 + h - 2, color, 1)


def seal_stamp(c, x0, y0, x1, y1, ink, paper, glyph=3, flip=False):
    """方形印章：ink 外框 + paper 内芯 + n 横 1 竖的抽象印纹。

    glyph=1/2/3 控制横画数；flip=True 时上下翻转，用于「反符倒印」。
    """
    c.rect(x0, y0, x1, y1, ink, fill=True)
    c.rect(x0 + 1, y0 + 1, x1 - 1, y1 - 1, paper, fill=True)
    _seal_glyph(c, x0 + 1, y0 + 1, x1 - x0 - 1, y1 - y0 - 1, glyph, ink, flip)


def _mat_core():
    c = Canvas()
    orb = c.circle(32, 32, 23, MIRROR[2])
    c.circle(31, 31, 22, MIRROR[1])
    # 螺旋
    pts = []
    turns = 2.7
    steps = 300
    for i in range(steps + 1):
        t = i / float(steps)
        a = t * turns * 2 * math.pi
        r = 3 + t * 15.5
        pts.append((32 + math.cos(a) * r, 32 + math.sin(a) * r))
    c.polyline(pts, hx('#6B4A9E'), 1)
    # 螺旋亮点
    for i in range(0, steps, 42):
        x, y = int(round(pts[i][0])), int(round(pts[i][1]))
        c.put(x, y, hx('#A46BE8'))
    c.circle(32, 32, 3.4, hx('#2C1B45'))
    c.circle(32, 32, 1.8, MIRROR[0])
    c.glint_line(18, 22, 26, 14, MIRROR[0], mask=orb)
    _finish(c, shade_mask=orb, highlight_mask=None)
    return c


# ---------------------------------------------------------------- 分发

def build_icon(entry):
    """按 manifest 条目绘制图标。entry 需含 builder/variant/state/part。"""
    b = entry.get('builder')
    style = SET_STYLE.get(entry.get('set', 'zhao'), SET_STYLE['zhao'])
    if b == 'sword':
        return draw_sword(style)
    if b == 'axe':
        return draw_axe(style)
    if b == 'bow':
        return draw_bow(style, entry.get('state', 'static'))
    if b == 'crossbow':
        return draw_crossbow(style, entry.get('state', 'static'))
    if b == 'twin_furnace':
        return draw_twin_furnace(style)
    if b == 'rub_furnace':
        return draw_rub_furnace(style)
    if b == 'armor':
        return draw_armor(style, entry.get('part'))
    if b == 'material':
        return draw_material(entry.get('material'), entry.get('variant'), style if entry.get('set') in SET_STYLE else None)
    raise ValueError('unknown builder: %r' % b)


# ---------------------------------------------------------------- 接触表

_FONT_CANDIDATES = (
    r'C:\Windows\Fonts\msyh.ttc',
    r'C:\Windows\Fonts\msyhbd.ttc',
    r'C:\Windows\Fonts\simhei.ttf',
    r'C:\Windows\Fonts\simsun.ttc',
)


def font(size, bold=False):
    cands = _FONT_CANDIDATES if not bold else (_FONT_CANDIDATES[1],) + _FONT_CANDIDATES
    for p in cands:
        try:
            return ImageFont.truetype(p, size)
        except Exception:
            continue
    try:
        return ImageFont.load_default(size=size)
    except Exception:
        return ImageFont.load_default()


def _checker(w, h, cell, c1, c2):
    im = Image.new('RGBA', (w, h), c1)
    d = ImageDraw.Draw(im)
    for y in range(0, h, cell):
        for x in range(0, w, cell):
            if ((x // cell) + (y // cell)) % 2:
                d.rectangle([x, y, x + cell - 1, y + cell - 1], fill=c2)
    return im


def checker_board(w, h, cell=16, c1=(21, 26, 33, 255), c2=(28, 34, 42, 255)):
    """深色棋盘底（接触表 / 预览共用）。"""
    return _checker(w, h, cell, c1, c2)


def contact_sheet(entries, out_path, cols=6, scale=4, title=None):
    """接触表：4× 最近邻、深色棋盘底、带标签。

    entries: [{'path':..., 'label':..., 'sub':...}, ...] 或 [(path, label), ...]
    """
    items = []
    for e in entries:
        if isinstance(e, dict):
            items.append((e['path'], e.get('label', os.path.basename(e['path'])), e.get('sub', '')))
        else:
            items.append((e[0], e[1], ''))
    if not items:
        raise ValueError('contact_sheet: empty entries')
    tile_w = ICON_SIZE * scale
    label_h = 40
    gap = 14
    pad = 24
    cols = max(1, min(cols, len(items)))
    rows = int(math.ceil(len(items) / float(cols)))
    title_h = 52 if title else 0
    W = pad * 2 + cols * tile_w + (cols - 1) * gap
    H = pad * 2 + title_h + rows * (tile_w + label_h) + (rows - 1) * gap
    sheet = Image.new('RGBA', (W, H), (10, 13, 18, 255))
    d = ImageDraw.Draw(sheet)
    if title:
        d.text((pad, pad - 4), title, font=font(26, True), fill=(232, 239, 244, 255))
    for idx, (path, label, sub) in enumerate(items):
        r, c = divmod(idx, cols)
        x = pad + c * (tile_w + gap)
        y = pad + title_h + r * (tile_w + label_h + gap)
        checker = _checker(tile_w, tile_w, 16 * scale, (21, 26, 33, 255), (28, 34, 42, 255))
        try:
            im = Image.open(path).convert('RGBA')
            if im.size != (ICON_SIZE, ICON_SIZE):
                im = im.resize((ICON_SIZE, ICON_SIZE), Image.NEAREST)
            im = im.resize((tile_w, tile_w), Image.NEAREST)
            checker.alpha_composite(im, (0, 0))
        except Exception as exc:
            ImageDraw.Draw(checker).text((8, 8), 'MISSING\n%s' % os.path.basename(path),
                                         font=font(14), fill=(224, 95, 168, 255))
        sheet.alpha_composite(checker, (x, y))
        d.rectangle([x, y, x + tile_w - 1, y + tile_w - 1], outline=(58, 70, 84, 255), width=1)
        d.text((x + 2, y + tile_w + 3), label, font=font(15, True), fill=(222, 232, 240, 255))
        if sub:
            d.text((x + 2, y + tile_w + 21), sub, font=font(12), fill=(140, 158, 174, 255))
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    sheet.convert('RGBA').save(out_path)
    return out_path


# ---------------------------------------------------------------- 自检工具

def audit_icon_file(path, max_colors=MAX_COLORS):
    """对已保存的 PNG 做与 Canvas.audit 同口径的检查。"""
    im = Image.open(path)
    if im.mode != 'RGBA':
        im = im.convert('RGBA')
    w, h = im.size
    px = im.load()
    errors = []
    warnings = []
    colors = {}
    opaque = set()
    for y in range(h):
        for x in range(w):
            c = px[x, y]
            if c[3] > 0:
                colors[c] = colors.get(c, 0) + 1
                opaque.add((x, y))
            if c[3] not in (0, 255):
                errors.append('半透明像素 (%d,%d)=%r' % (x, y, c))
                if len(errors) > 8:
                    break
    if (w, h) != (ICON_SIZE, ICON_SIZE):
        errors.append('尺寸 %d×%d，要求 64×64' % (w, h))
    if len(colors) > max_colors:
        errors.append('用色 %d 超过 %d' % (len(colors), max_colors))
    border_bad = [(x, y) for (x, y) in opaque
                  if x in (0, w - 1) or y in (0, h - 1)]
    if border_bad:
        errors.append('最外圈不透明：%r' % (border_bad[:4],))
    body = {p for p in opaque if px[p[0], p[1]][:3] != OUTLINE[:3]}
    if body:
        xs = [p[0] for p in body]
        ys = [p[1] for p in body]
        if min(xs) < BODY_INSET or min(ys) < BODY_INSET or \
           max(xs) > w - BODY_INSET - 1 or max(ys) > h - BODY_INSET - 1:
            errors.append('主体越界 bbox=(%d,%d,%d,%d)' % (min(xs), min(ys), max(xs), max(ys)))
    bad_outline = []
    for (x, y) in opaque:
        c = px[x, y]
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and px[nx, ny][3] == 0:
                if c[:3] != OUTLINE[:3]:
                    bad_outline.append((x, y))
                break
    if bad_outline:
        errors.append('外沿缺描边 %d 个（首个 %r）' % (len(bad_outline), bad_outline[0]))
    ratio = len(opaque) / float(w * h)
    if ratio < 0.10:
        warnings.append('覆盖率偏低 %.1f%%' % (ratio * 100))
    if ratio > 0.72:
        warnings.append('覆盖率偏高 %.1f%%' % (ratio * 100))
    bbox = None
    if opaque:
        xs = [p[0] for p in opaque]
        ys = [p[1] for p in opaque]
        bbox = (min(xs), min(ys), max(xs), max(ys))
    return {
        'ok': not errors,
        'errors': errors,
        'warnings': warnings,
        'size': (w, h),
        'colors': len(colors),
        'opaque_pixels': len(opaque),
        'coverage': round(ratio, 4),
        'bbox': bbox,
    }


def silhouette_iou(path_a, path_b):
    """两个图标的 alpha 剪影 IoU，用于检查武器剪影是否过于相似（<0.55 视为可区分）。"""
    a = Image.open(path_a).convert('RGBA')
    b = Image.open(path_b).convert('RGBA')
    if a.size != b.size:
        raise ValueError('size mismatch: %r vs %r' % (a.size, b.size))
    pa, pb = a.load(), b.load()
    sa = {(x, y) for y in range(a.size[1]) for x in range(a.size[0]) if pa[x, y][3] > 0}
    sb = {(x, y) for y in range(b.size[1]) for x in range(b.size[0]) if pb[x, y][3] > 0}
    inter = len(sa & sb)
    union = len(sa | sb)
    return inter / float(union) if union else 1.0


# ---------------------------------------------------------------- CLI

def _main():
    ap = argparse.ArgumentParser(description='mirror_art 自检 / 接触表')
    ap.add_argument('--audit', nargs='+', help='待检查的 PNG')
    ap.add_argument('--sheet', nargs='+', help='生成接触表的 PNG')
    ap.add_argument('--out', default='out/art/contact_sheet.png')
    ap.add_argument('--cols', type=int, default=6)
    ap.add_argument('--title', default='镜中倒影 · 接触表')
    args = ap.parse_args()
    if args.audit:
        bad = 0
        for p in args.audit:
            r = audit_icon_file(p)
            print(('OK  ' if r['ok'] else 'FAIL') + ' %s  size=%s colors=%d coverage=%.1f%%' %
                  (p, r['size'], r['colors'], r['coverage'] * 100))
            for e in r['errors']:
                print('   ! ' + e)
            for w in r['warnings']:
                print('   ~ ' + w)
            bad += 0 if r['ok'] else 1
        return 1 if bad else 0
    if args.sheet:
        entries = [{'path': p, 'label': os.path.splitext(os.path.basename(p))[0]} for p in args.sheet]
        print(contact_sheet(entries, args.out, cols=args.cols, title=args.title))
        return 0
    ap.print_help()
    return 0


if __name__ == '__main__':
    raise SystemExit(_main())
