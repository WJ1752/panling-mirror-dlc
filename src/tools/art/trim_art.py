# -*- coding: utf-8 -*-
"""
trim_art —— 《梦回盘灵：镜中倒影》盔甲底甲 + 盔甲纹饰共用画具

职责（与《镜中倒影_盔甲纹饰规范_v1.0.md》一致）：
  * 从 client jar / 本体资源包读取参考贴图，可复现地落到 out/trim_ref/；
  * 读取 vanilla netherite_layer_1/2 的 alpha，作为底甲与纹饰的唯一轮廓遮罩；
  * 128×64 底甲画布（镜银/暗银，无青色发光，仅少量镜面反光）；
  * 64×32 纹饰画布（只用原版 trim_palette 的 8 个灰度值，1px 细线，稀疏）；
  * 8×1 调色板生成（深→浅；配套 plm 专用 palette_key 见规范 §5.4）；
  * 底甲 + 纹饰合成、纸偶预览、接触表、自检。

坐标约定：
  * 盔甲贴图为 64×32 逻辑 UV；底甲为其 2×（128×64）。
  * 本模块所有“放置区”用 64×32 坐标书写，底甲绘制时统一乘 2。
  * 纹饰贴图必须 64×32，且不透明像素必须落在 netherite alpha 内。

对外 API（可 import）：
  GRAYS / MIRROR / SETS / SET_ORDER / ZONES
  extract_references(dest)                  解包参考图
  load_vanilla(name) / load_panling(name)   读参考图
  netherite_mask(layer, scale=1)            alpha 遮罩（L 模式）
  TrimCanvas                                64×32 纹饰画布（裁剪到遮罩）
  BaseCanvas                                128×64 底甲画布
  build_base_armor(layer, seed)             生成镜银底甲
  paint_trim(canvas, set_key, layer)        画一层的完整纹饰（六套母题）
  build_trim(set_key, layer)                生成 64×32 纹饰（灰度）
  palette_image(set_key) / save_palette     8×1 调色板（深→浅）
  colorize_trim(trim, set_key)              灰度纹饰 → 强调色预览
  composite(base, trim, set_key)            底甲 + 纹饰合成
  paper_doll(layer1, layer2, scale)         2D 纸偶预览
  contact_sheet(panels, out_path, ...)      接触表
  audit_trim(path, layer) / audit_base(path, layer) / audit_palette(path)

CLI：
  python -I src/tools/art/trim_art.py --extract
  python -I src/tools/art/trim_art.py --audit out/trim_sample/trim_zhao_layer1.png --kind trim --layer 1
"""
from __future__ import annotations

import argparse
import json
import math
import os
import random
import sys
from functools import lru_cache
import zipfile
from collections import deque

from PIL import Image, ImageDraw, ImageFont

# ---------------------------------------------------------------- 路径与常量

HERE = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
PACK_ZIP = os.path.join(PROJECT_ROOT, "梦回盘灵服务端", "resourcepack",
                        "panling-1.20-resourcepack-1.1.0b.zip")
CLIENT_JAR = os.environ.get("PLM_CLIENT_JAR") or os.path.join(
    os.environ.get("APPDATA", os.path.expanduser("~")), ".minecraft", "versions", "1.20.1", "1.20.1.jar"
)
REF_ROOT = os.path.join(PROJECT_ROOT, "out", "trim_ref")
OUT_ROOT = os.path.join(PROJECT_ROOT, "out")

PACK_ARMOR = "assets/minecraft/textures/models/armor/"
VANILLA_ARMOR = PACK_ARMOR
VANILLA_TRIM = "assets/minecraft/textures/trims/"
ATLAS_PATH = "assets/minecraft/atlases/armor_trims.json"

# 原版 trim_palette 的 8 个灰度值（顺序：224→0；本规范只允许这 8 个值）
GRAYS = (0, 32, 64, 96, 128, 160, 192, 224)
G0, G1, G2, G3, G4, G5, G6, G7 = GRAYS
GRAY_SET = frozenset(GRAYS)

# 镜银主色阶（底甲）；与美术规范 §3.1 同族，但底甲允许更深的暗部
# 深→浅（与调色板/渲染索引一致；fill_gradient 直接按索引取色）
MIRROR_HEX = ("#10151A", "#1C2530", "#2C3944", "#47596A",
              "#6E8494", "#9DB2BE", "#C9DCE6", "#E2EFF5", "#F4FBFF")
MIRROR = tuple(tuple(int(h[i:i + 2], 16) for i in (1, 3, 5)) + (255,)
               for h in MIRROR_HEX)

MAX_TRIM_COVERAGE = {"layer_1": 0.08, "leggings": 0.03}   # 稀疏度硬上限
MIN_TRIM_COVERAGE = {"layer_1": 0.03, "leggings": 0.007}  # 低于此值说明没画东西

# ---------------------------------------------------------------- 六套定义

# stops：8 步色阶，深→浅。既用于 8×1 调色板，也用于预览上色。
SETS = {
    "zhao": {
        "name": "照心", "cn_suffix": "镜", "motif": "rings",
        "motif_cn": "同心圆 / 镜盘",
        "accent": ["#F2D48A", "#FFF6E0"], "accent_dark": "#A87C2E",
        "stops": ["#2A1D0B", "#4A3312", "#6E4C1B", "#A87C2E",
                  "#C9A24A", "#E2C070", "#F2D48A", "#FFF6E0"],
        "gray_roles": {"line": G6, "shadow": G3, "spark": G7},
        "armor": "照心镜",
    },
    "lie": {
        "name": "裂影", "cn_suffix": "镜", "motif": "crack",
        "motif_cn": "斜向折痕 + 碎片",
        "accent": ["#A46BE8", "#E05FA8"], "accent_dark": "#5E3A85",
        "stops": ["#22102F", "#3B1E52", "#5E3A85", "#7A45A8",
                  "#A46BE8", "#C77AE8", "#E88FC0", "#F7DCEF"],
        "gray_roles": {"line": G6, "shadow": G4, "spark": G7},
        "armor": "裂影镜",
    },
    "jing": {
        "name": "镜花", "cn_suffix": "轻甲", "motif": "flower",
        "motif_cn": "五瓣花 + 水月弧",
        "accent": ["#F2A7C3", "#FFF0F5"], "accent_dark": "#B05C7C",
        "stops": ["#2A1420", "#4A2233", "#7A3F55", "#B05C7C",
                  "#D07E9C", "#F2A7C3", "#FAD0DF", "#FFF0F5"],
        "gray_roles": {"line": G6, "shadow": G3, "spark": G7},
        "armor": "镜花轻甲",
    },
    "can": {
        "name": "残影", "cn_suffix": "轻甲", "motif": "ghost",
        "motif_cn": "偏移双线 + 速度线",
        "accent": ["#5FD6E8", "#1F6F78"], "accent_dark": "#134A50",
        "stops": ["#0A1E22", "#123A40", "#134A50", "#1F6F78",
                  "#3A9AA6", "#5FD6E8", "#A8E9F2", "#E6FAFC"],
        "gray_roles": {"line": G6, "shadow": G4, "spark": G7},
        "armor": "残影轻甲",
    },
    "twin": {
        "name": "双生", "cn_suffix": "镜袍", "motif": "twin",
        "motif_cn": "左右对称双半 + 双点",
        # 左金右蓝：靠灰度分工实现（高灰度→调色板浅端=金，低灰度→深端=蓝）
        "accent": ["#E8C060", "#5A8FE8"], "accent_dark": "#2F5AA8",
        "stops": ["#14294F", "#1E3F73", "#2F5AA8", "#4A78C0",
                  "#8FA6C8", "#C9B47E", "#E8C060", "#FFF0C8"],
        "gray_roles": {"line": G7, "shadow": G2, "spark": G6},
        "armor": "双生镜袍",
    },
    "rub": {
        "name": "拓印", "cn_suffix": "镜袍", "motif": "stamp",
        "motif_cn": "方印边 + 纸纹",
        "accent": ["#C8483C", "#2B2B2B"], "accent_dark": "#7A2A24",
        "stops": ["#1A1512", "#2B2B2B", "#4A2320", "#7A2A24",
                  "#C8483C", "#D98B6E", "#E8DFC8", "#F7F1E2"],
        "gray_roles": {"line": G6, "shadow": G2, "spark": G7},
        "armor": "拓印镜袍",
    },
}
SET_ORDER = ("zhao", "lie", "jing", "can", "twin", "rub")

# 64×32 逻辑 UV 放置区（(x0,y0,w,h)，含端点 x0..x0+w-1）
ZONES = {
    1: {
        "helmet_top":     (8, 0, 8, 8),
        "helmet_front":   (8, 8, 8, 8),
        "helmet_back":    (24, 8, 8, 8),
        "chest_front":    (20, 20, 8, 12),
        "chest_back":     (32, 20, 8, 12),
        "arm_front":      (44, 20, 4, 12),
        "arm_top":        (44, 16, 4, 4),
        "arm_back":       (52, 20, 4, 12),
        "boot_front":     (4, 20, 4, 12),
        "boot_outer":     (0, 20, 4, 12),
        "boot_inner":     (8, 20, 4, 12),
    },
    2: {
        "legs_front":     (4, 20, 4, 12),
        "legs_back":      (12, 20, 4, 12),
        "legs_outer":     (0, 20, 4, 12),
        "legs_inner":     (8, 20, 4, 12),
        "legs_waist_f":   (20, 20, 8, 12),
        "legs_waist_b":   (32, 20, 8, 12),
    },
}

# 纹饰“甲带”基准（对齐 sentry / sentry_leggings 实测像素）
SENTRY_BANDS = {
    1: {
        "helmet_crest": (11, 0, 2, 8),      # 头顶中线
        "helmet_brow": (11, 8, 2, 3),       # 额心
        "helmet_back": (27, 8, 2, 6),       # 后脑中线
        "shoulder_top": (44, 16, 2, 3),     # 肩顶
        "shoulder_ring": (40, 20, 6, 3),    # 肩/上臂环
        "arm_back": (54, 20, 2, 3),
        "chest_band": (21, 23, 6, 6),       # 胸心
        "boot_band": (0, 26, 16, 2),        # 靴踝一圈
    },
    2: {
        "thigh_band": (0, 22, 16, 4),       # 大腿一圈（sentry_leggings 同位）
        "knee_band": (0, 29, 16, 1),
    },
}

# 底甲内部甲片接缝（64×32 坐标，仅画横缝；裁在遮罩内）
SEAMS = {
    1: [
        ("chest_lower", (20, 27, 8)),
        ("chest_waist", (20, 30, 8)),
        ("arm_ring", (40, 28, 16)),
        ("boot_ankle", (0, 24, 16)),
    ],
    2: [
        ("legs_knee", (0, 26, 16)),
        ("legs_ankle", (0, 30, 16)),
    ],
}

# UV 正面（纸偶预览用；已用本体 diamond 贴图验证）
DOLL_FACES = {
    "head": (8, 8, 8, 8),
    "body": (20, 20, 8, 12),
    "arm": (44, 20, 4, 12),
    "leg": (4, 20, 4, 12),
}

# ---------------------------------------------------------------- 小工具


def hx(value):
    """'#RRGGBB' -> (r,g,b,255)。"""
    value = value.lstrip("#")
    return (int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16), 255)


def to_hex(color):
    return "#%02X%02X%02X" % tuple(color[:3])


def luminance(color):
    r, g, b = color[:3]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def _lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(3))


def ramp(stops, n=8):
    """把任意数量的色标插值成 n 步 RGB 列表（深→浅按传入顺序）。"""
    cols = [hx(s)[:3] for s in stops]
    if len(cols) == n:
        return cols
    out = []
    for i in range(n):
        pos = i * (len(cols) - 1) / (n - 1)
        lo = int(math.floor(pos))
        hi = min(lo + 1, len(cols) - 1)
        out.append(_lerp(cols[lo], cols[hi], pos - lo))
    return out


def _font(size=14, bold=False):
    candidates = (
        r"C:/Windows/Fonts/msyhbd.ttc" if bold else r"C:/Windows/Fonts/msyh.ttc",
        r"C:/Windows/Fonts/simhei.ttf",
        r"C:/Windows/Fonts/arial.ttf",
    )
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def _checker(w, h, cell=8, c1=(26, 31, 38, 255), c2=(34, 40, 49, 255)):
    im = Image.new("RGBA", (w, h), c1)
    d = ImageDraw.Draw(im)
    for y in range(0, h, cell):
        for x in range(0, w, cell):
            if ((x // cell) + (y // cell)) % 2 == 0:
                d.rectangle([x, y, x + cell - 1, y + cell - 1], fill=c2)
    return im


# ---------------------------------------------------------------- 参考读取


def _zip_bytes(zip_path, inner):
    with zipfile.ZipFile(zip_path) as zf:
        return zf.read(inner)


@lru_cache(maxsize=16)
def _cached_panling(name):
    return Image.open(_Bytes(_zip_bytes(PACK_ZIP, PACK_ARMOR + name))).convert("RGBA")


def load_panling(name):
    """读本体资源包里的 armor 贴图，如 'diamond_layer_1.png'（返回副本）。"""
    return _cached_panling(name).copy()


@lru_cache(maxsize=16)
def _cached_vanilla(name):
    return Image.open(_Bytes(_zip_bytes(CLIENT_JAR, "assets/minecraft/textures/" + name))).convert("RGBA")


def load_vanilla(name):
    """读 client jar 里的贴图，name 相对 textures/，如 'models/armor/netherite_layer_1.png'（返回副本）。"""
    return _cached_vanilla(name).copy()


@lru_cache(maxsize=1)
def _cached_atlas():
    return json.loads(_zip_bytes(CLIENT_JAR, ATLAS_PATH).decode("utf-8"))


def load_atlas():
    return json.loads(json.dumps(_cached_atlas()))


class _Bytes:
    """PIL 需要 file-like；把 bytes 包一层，避免临时文件。"""

    def __init__(self, data):
        import io
        self._io = io.BytesIO(data)

    def read(self, *a):
        return self._io.read(*a)

    def seek(self, *a):
        return self._io.seek(*a)

    def tell(self):
        return self._io.tell()


REFERENCE_FILES = {
    "panling": ["diamond_layer_1.png", "diamond_layer_2.png", "iron_layer_1.png",
                "iron_layer_2.png", "gold_layer_1.png", "gold_layer_2.png",
                "chainmail_layer_1.png", "chainmail_layer_2.png"],
    "vanilla": ["models/armor/netherite_layer_1.png", "models/armor/netherite_layer_2.png",
                "trims/models/armor/sentry.png", "trims/models/armor/sentry_leggings.png",
                "trims/color_palettes/trim_palette.png",
                "trims/color_palettes/quartz.png",
                "atlases/armor_trims.json"],
}


def extract_references(dest=REF_ROOT, verbose=True):
    """解包参考到 dest/{panling,vanilla}/，返回落盘路径列表。"""
    os.makedirs(os.path.join(dest, "panling"), exist_ok=True)
    os.makedirs(os.path.join(dest, "vanilla"), exist_ok=True)
    written = []
    for sub, names in REFERENCE_FILES.items():
        zip_path = PACK_ZIP if sub == "panling" else CLIENT_JAR
        for name in names:
            inner = (PACK_ARMOR + name) if sub == "panling" else ("assets/minecraft/textures/" + name)
            if name.startswith("atlases/"):
                inner = "assets/minecraft/" + name
            data = _zip_bytes(zip_path, inner)
            out = os.path.join(dest, sub, os.path.basename(name))
            with open(out, "wb") as fh:
                fh.write(data)
            written.append(out)
            if verbose:
                print("ref  %-58s %6d B" % (os.path.relpath(out, PROJECT_ROOT), len(data)))
    return written


@lru_cache(maxsize=4)
def _cached_mask(layer=1, scale=1):
    im = _cached_vanilla("models/armor/netherite_layer_%d.png" % layer)
    mask = im.getchannel("A").point(lambda v: 255 if v > 0 else 0)
    if scale != 1:
        mask = mask.resize((mask.width * scale, mask.height * scale), Image.NEAREST)
    return mask


def netherite_mask(layer=1, scale=1):
    """vanilla netherite alpha（L 模式）。scale=2 得到 128×64；返回副本。"""
    if layer not in (1, 2):
        raise ValueError("layer must be 1 or 2")
    return _cached_mask(layer, scale).copy()


def mask_boxes(layer=1):
    """返回 64×32 遮罩内每个 UV 放置区的像素数，便于校验落点。"""
    mask = netherite_mask(layer)
    px = mask.load()
    out = {}
    for name, (x0, y0, w, h) in ZONES[layer].items():
        out[name] = sum(1 for y in range(y0, y0 + h) for x in range(x0, x0 + w)
                        if px[x, y] > 0)
    return out


# ---------------------------------------------------------------- 画布


class TrimCanvas:
    """64×32 纹饰画布：只写灰度，自动裁到 netherite alpha，alpha 恒为 255/0。"""

    def __init__(self, layer=1, size=(64, 32), clip=True):
        self.layer = layer
        self.w, self.h = size
        self.im = Image.new("RGBA", (self.w, self.h), (0, 0, 0, 0))
        self.px = self.im.load()
        self.mask = netherite_mask(layer) if clip else None

    # -- 基础
    def in_bounds(self, x, y):
        return 0 <= x < self.w and 0 <= y < self.h

    def put(self, x, y, gray):
        x, y = int(round(x)), int(round(y))
        if gray not in GRAY_SET:
            raise ValueError("纹饰只允许 trim_palette 的 8 个灰度值，收到 %r" % (gray,))
        if not self.in_bounds(x, y):
            return
        if self.mask is not None and self.mask.getpixel((x, y)) == 0:
            return
        self.px[x, y] = (gray, gray, gray, 255)

    def get(self, x, y):
        return self.px[x, y]

    def block(self, x, y, w, h, gray):
        for yy in range(y, y + h):
            for xx in range(x, x + w):
                self.put(xx, yy, gray)

    # -- 1px 线
    def line(self, x0, y0, x1, y1, gray):
        x0, y0, x1, y1 = int(round(x0)), int(round(y0)), int(round(x1)), int(round(y1))
        dx, dy = abs(x1 - x0), abs(y1 - y0)
        sx = 1 if x0 < x1 else -1
        sy = 1 if y0 < y1 else -1
        err = dx - dy
        while True:
            self.put(x0, y0, gray)
            if x0 == x1 and y0 == y1:
                break
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x0 += sx
            if e2 < dx:
                err += dx
                y0 += sy

    def polyline(self, points, gray):
        for (x0, y0), (x1, y1) in zip(points, points[1:]):
            self.line(x0, y0, x1, y1, gray)

    def dashed(self, x0, y0, x1, y1, gray, on=2, off=2):
        """1px 虚线（只支持水平/垂直/45°）。"""
        steps = max(abs(x1 - x0), abs(y1 - y0))
        for i in range(steps + 1):
            if (i // max(1, on)) % 2 == 0:
                x = x0 + (x1 - x0) * i / steps if steps else x0
                y = y0 + (y1 - y0) * i / steps if steps else y0
                self.put(x, y, gray)

    # -- 圆 / 环 / 弧 / 花瓣
    def ring(self, cx, cy, r, gray, thickness=1):
        """整数像素圆环；r 可以是 .5。"""
        r2o = (r + 0.5) ** 2
        r2i = max(0.0, (r - 0.5 - (thickness - 1)) ** 2)
        for y in range(int(math.floor(cy - r - 1)), int(math.ceil(cy + r + 1)) + 1):
            for x in range(int(math.floor(cx - r - 1)), int(math.ceil(cx + r + 1)) + 1):
                d2 = (x - cx) ** 2 + (y - cy) ** 2
                if r2i <= d2 <= r2o:
                    self.put(x, y, gray)

    def disc(self, cx, cy, r, gray):
        rr = (r + 0.5) ** 2
        for y in range(int(math.floor(cy - r - 1)), int(math.ceil(cy + r + 1)) + 1):
            for x in range(int(math.floor(cx - r - 1)), int(math.ceil(cx + r + 1)) + 1):
                if (x - cx) ** 2 + (y - cy) ** 2 <= rr:
                    self.put(x, y, gray)

    def arc(self, cx, cy, r, a0, a1, gray):
        a0, a1 = math.radians(a0), math.radians(a1)
        steps = max(8, int(abs(a1 - a0) * r * 2))
        for i in range(steps + 1):
            a = a0 + (a1 - a0) * i / steps
            self.put(cx + r * math.cos(a), cy + r * math.sin(a), gray)

    def petal_flower(self, cx, cy, r, petal_gray, center_gray=None, petals=5):
        """
        五瓣花。64×32 的甲带上 r 通常 ≤3：用 5 个 1px 花瓣点（梅花式），
        保证在 2×2 纹素块下仍能读出“花”，而不是一团。
        r > 3.2 时才用花瓣小环。
        """
        if r <= 3.2:
            pdist = 2.2 if r >= 2.4 else 1.6
            for k in range(petals):
                a = math.radians(-90 + 360.0 * k / petals)
                self.put(round(cx + pdist * math.cos(a)),
                         round(cy + pdist * math.sin(a)), petal_gray)
        else:
            pr = max(1.0, r * 0.44)
            pdist = r * 0.56
            for k in range(petals):
                a = math.radians(-90 + 360.0 * k / petals)
                self.ring(cx + pdist * math.cos(a), cy + pdist * math.sin(a), pr, petal_gray)
        if center_gray is not None:
            # 中心只点 1px，避免 64×32 下花心糊成块
            self.put(round(cx), round(cy), center_gray)

    # -- 裂纹 / 碎片
    def crack(self, x0, y0, x1, y1, gray, segments=3, jitter=1, seed=0, shadow=None):
        rng = random.Random(seed)
        pts = []
        for i in range(segments + 1):
            t = i / segments
            x = x0 + (x1 - x0) * t
            y = y0 + (y1 - y0) * t
            if i not in (0, segments):
                x += rng.randint(-jitter, jitter)
                y += rng.randint(-jitter, jitter)
            pts.append((round(x), round(y)))
        if shadow is not None:
            self.polyline([(px + 1, py + 1) for px, py in pts], shadow)
        self.polyline(pts, gray)
        return pts

    def shard(self, cx, cy, size, gray):
        """3–5px 的碎片三角。"""
        s = max(1, size)
        self.polyline([(cx - s, cy + s), (cx, cy - s), (cx + s, cy + s), (cx - s, cy + s)], gray)

    # -- 印章
    def seal(self, x0, y0, x1, y1, frame_gray, bar_gray=None, inner_gray=None):
        self.rect_outline(x0, y0, x1, y1, frame_gray)
        if inner_gray is not None and x1 - x0 >= 4 and y1 - y0 >= 4:
            for y in range(y0 + 1, y1):
                for x in range(x0 + 1, x1):
                    self.put(x, y, inner_gray)
        if bar_gray is not None:
            my = (y0 + y1) // 2
            for y in (my - 1, my + 1):
                self.line(x0 + 1, y, x1 - 1, y, bar_gray)
            self.line((x0 + x1) // 2, y0 + 1, (x0 + x1) // 2, y1 - 1, bar_gray)

    def rect_outline(self, x0, y0, x1, y1, gray):
        self.line(x0, y0, x1, y0, gray)
        self.line(x1, y0, x1, y1, gray)
        self.line(x1, y1, x0, y1, gray)
        self.line(x0, y1, x0, y0, gray)

    # -- 统计 / 输出
    def colors(self):
        seen = set()
        for y in range(self.h):
            for x in range(self.w):
                if self.px[x, y][3]:
                    seen.add(self.px[x, y])
        return seen

    def coverage(self):
        n = sum(1 for y in range(self.h) for x in range(self.w) if self.px[x, y][3])
        return n / float(self.w * self.h)

    def bbox(self):
        xs, ys = [], []
        for y in range(self.h):
            for x in range(self.w):
                if self.px[x, y][3]:
                    xs.append(x)
                    ys.append(y)
        return (min(xs), min(ys), max(xs), max(ys)) if xs else None

    def save(self, path):
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        self.im.save(path)
        return path

    def to_image(self):
        return self.im.copy()


class BaseCanvas:
    """128×64 底甲画布；坐标用 64×32 逻辑坐标，内部 ×2。"""

    def __init__(self, layer=1, size=(128, 64)):
        if size != (128, 64):
            raise ValueError("底甲画布固定 128×64")
        self.layer = layer
        self.w, self.h = size
        self.im = Image.new("RGBA", size, (0, 0, 0, 0))
        self.px = self.im.load()
        self.mask = netherite_mask(layer, scale=2)

    def put(self, x, y, color):
        if 0 <= x < self.w and 0 <= y < self.h and self.mask.getpixel((x, y)) > 0:
            self.px[x, y] = tuple(color[:3]) + (255,)

    def put64(self, x, y, color):
        """用 64×32 逻辑坐标写 2×2 块。"""
        for dy in (0, 1):
            for dx in (0, 1):
                self.put(x * 2 + dx, y * 2 + dy, color)

    def fill_ramp(self, tone_fn, ramp_colors, bayer=True):
        bayer4 = ((0, 8, 2, 10), (12, 4, 14, 6), (3, 11, 1, 9), (15, 7, 13, 5))
        for y in range(self.h):
            for x in range(self.w):
                if self.mask.getpixel((x, y)) == 0:
                    continue
                t = tone_fn(x, y)
                t = max(0.0, min(1.0, t))
                if bayer:
                    t += (bayer4[y % 4][x % 4] / 16.0 - 0.5) * (1.0 / (len(ramp_colors) - 1)) * 1.05
                idx = int(round(max(0.0, min(1.0, t)) * (len(ramp_colors) - 1)))
                self.px[x, y] = tuple(ramp_colors[idx][:3]) + (255,)

    def fill_gradient(self, tone_fn, ramp_colors):
        """连续色阶（不量化）——本体 128×64 是手绘多色，底甲走这条。"""
        stops = [tuple(c[:3]) for c in ramp_colors]
        n = len(stops)
        for y in range(self.h):
            for x in range(self.w):
                if self.mask.getpixel((x, y)) == 0:
                    continue
                t = max(0.0, min(1.0, tone_fn(x, y)))
                pos = t * (n - 1)
                lo = int(math.floor(pos))
                hi = min(lo + 1, n - 1)
                self.px[x, y] = _lerp(stops[lo], stops[hi], pos - lo) + (255,)

    def line64(self, x0, y0, x1, y1, color):
        x0, y0, x1, y1 = x0 * 2, y0 * 2, x1 * 2, y1 * 2
        dx, dy = abs(x1 - x0), abs(y1 - y0)
        sx = 1 if x0 < x1 else -1
        sy = 1 if y0 < y1 else -1
        err = dx - dy
        while True:
            self.put(x0, y0, color)
            if x0 == x1 and y0 == y1:
                break
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x0 += sx
            if e2 < dx:
                err += dx
                y0 += sy

    def save(self, path):
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        self.im.save(path)
        return path

    def to_image(self):
        return self.im.copy()


# ---------------------------------------------------------------- 底甲绘制


def _depth_map(mask):
    """遮罩内部到最近透明像素的 4-邻域距离（BFS）。"""
    w, h = mask.size
    dist = [[0] * w for _ in range(h)]
    q = deque()
    px = mask.load()
    for y in range(h):
        for x in range(w):
            if px[x, y] == 0:
                continue
            if (x == 0 or y == 0 or x == w - 1 or y == h - 1 or
                    px[x - 1, y] == 0 or px[x + 1, y] == 0 or
                    px[x, y - 1] == 0 or px[x, y + 1] == 0):
                dist[y][x] = 1
                q.append((x, y))
    while q:
        x, y = q.popleft()
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < w and 0 <= ny < h and px[nx, ny] and dist[ny][nx] == 0:
                dist[ny][nx] = dist[y][x] + 1
                q.append((nx, ny))
    return dist


def _hash_noise(x, y, seed=0):
    n = (x * 374761393 + y * 668265263 + seed * 69069) & 0xFFFFFFFF
    n = (n ^ (n >> 13)) * 1274126177 & 0xFFFFFFFF
    return ((n ^ (n >> 16)) & 0xFFFF) / 65535.0


def _smooth_noise(x, y, cell, seed):
    """4×4 双线性值噪声，尺度 cell 像素。"""
    gx, gy = x / cell, y / cell
    x0, y0 = int(math.floor(gx)), int(math.floor(gy))
    fx, fy = gx - x0, gy - y0
    fx = fx * fx * (3 - 2 * fx)
    fy = fy * fy * (3 - 2 * fy)
    a = _hash_noise(x0, y0, seed)
    b = _hash_noise(x0 + 1, y0, seed)
    c = _hash_noise(x0, y0 + 1, seed)
    d = _hash_noise(x0 + 1, y0 + 1, seed)
    return (a * (1 - fx) + b * fx) * (1 - fy) + (c * (1 - fx) + d * fx) * fy


def build_base_armor(layer=1, seed=20261103):
    """
    生成 128×64 镜银底甲。
    规则：alpha 严格等于 netherite 2×；镜银 9 阶 + 4×4 有序抖动；
    左上受光/右下压暗；甲片接缝 1px；少量 #F4FBFF 反光（≤2%）。
    """
    bc = BaseCanvas(layer)
    mask = bc.mask
    depth2 = _depth_map(mask)
    w, h = mask.size
    mask_px = mask.load()

    def tone(x, y):
        d = depth2[y][x]
        deep = min(1.0, (d - 1) / 9.0)
        # 主体：中暗，靠内部提亮
        t = 0.30 + 0.38 * deep
        # 大尺度对角光（左上亮、右下暗），不依赖每一条边缘
        t += 0.07 * (1.0 - (x / float(w) * 0.55 + y / float(h) * 0.45))
        # 甲片起伏
        t += (_smooth_noise(x, y, 9, seed) - 0.5) * 0.07
        # 拉丝金属：1px 斜向细纹（本体手绘也有同类笔触）
        phase = (x + y) % 13
        if phase == 0:
            t += 0.045
        elif phase == 1:
            t -= 0.025
        # 轮廓内 1–2px：压成暗边，读作甲片厚度
        if d == 1:
            t = 0.10 + 0.05 * _hash_noise(x, y, seed)
        elif d == 2:
            t *= 0.74
        # 右下轮廓加暗，左上轮廓略提
        if d <= 2:
            up = y == 0 or mask_px[x, y - 1] == 0
            left = x == 0 or mask_px[x - 1, y] == 0
            down = y == h - 1 or mask_px[x, y + 1] == 0
            right = x == w - 1 or mask_px[x + 1, y] == 0
            if up or left:
                t += 0.10
            if down or right:
                t -= 0.05
        return t

    bc.fill_gradient(tone, MIRROR)

    # 每个 UV 面做 1px 倒角：上沿提亮、下沿压暗（只画在遮罩内）
    # 4px 宽的窄面（手指/腿侧）不画竖倒角，否则整条腿会变成斑马纹。
    for _name, (x0, y0, zw, zh) in ZONES[layer].items():
        x1, y1 = x0 + zw - 1, y0 + zh - 1
        if zh >= 6:
            for x in range(x0 + 1, x1):
                bc.put64(x, y0, hx("#9DB2BE")[:3])
                bc.put64(x, y1, hx("#1C2530")[:3])
        if zw >= 6:
            for y in range(y0 + 1, y1):
                bc.put64(x0, y, hx("#6E8494")[:3])
                bc.put64(x1, y, hx("#2C3944")[:3])

    # 甲片接缝：暗线 + 下沿 1px 高光
    for _name, (x0, y, x1) in SEAMS[layer]:
        bc.line64(x0, y, x1 - 1, y, hx("#1C2530")[:3])
        bc.line64(x0, y + 1, x1 - 1, y + 1, hx("#6E8494")[:3])

    # 铆钉：接缝两端 1 颗（64 坐标 1px → 2×2）
    for _name, (x0, y, x1) in SEAMS[layer]:
        for rx in (x0 + 1, x1 - 2):
            bc.put64(rx, y, hx("#C9DCE6")[:3])

    # 铆钉：甲片四角/接缝处的 1px 亮点（64 坐标）
    for rx, ry in ((21, 21), (26, 21), (21, 29), (26, 29),
                   (41, 22), (42, 29), (1, 22), (14, 29)):
        bc.put64(rx, ry, hx("#C9DCE6")[:3])

    # 镜面反光：3 条短斜线，裁在遮罩内（面积 <2%）
    for (x0, y0, x1, y1) in ((8, 3, 10, 5), (21, 21, 24, 24), (41, 21, 42, 22)):
        bc.line64(x0, y0, x1, y1, hx("#F4FBFF")[:3])

    return bc


# ---------------------------------------------------------------- 六套纹饰


def _badge(canvas, kind, cx, cy, r, roles, seed=0):
    """在 (cx,cy) 画母题徽记；r 为外接半径（3–4）。"""
    line = roles["line"]
    shadow = roles["shadow"]
    spark = roles["spark"]

    if kind == "rings":
        canvas.ring(cx, cy, r, line)
        canvas.ring(cx, cy, max(1.0, r - 1.6), shadow)
        canvas.put(cx, cy, spark)
        for dx, dy in ((0, -r - 1), (0, r + 1), (-r - 1, 0), (r + 1, 0)):
            canvas.put(cx + dx, cy + dy, shadow)

    elif kind == "crack":
        canvas.crack(cx - r, cy - r, cx + r, cy + r, line,
                     segments=3, jitter=1, seed=seed, shadow=shadow)
        canvas.crack(cx + r, cy - r + 1, cx + 1, cy + 1, shadow,
                     segments=2, jitter=1, seed=seed + 7)
        canvas.shard(cx - r + 1, cy + r - 1, 1, line)
        canvas.shard(cx + r - 1, cy - r + 1, 1, spark)

    elif kind == "flower":
        # 胸心只放五瓣花；水月弧放在甲带（每 5px 一段 2px 弧点），避免糊成一团
        canvas.petal_flower(cx, cy, r, line, center_gray=spark)

    elif kind == "ghost":
        canvas.ring(cx, cy, r, line)
        canvas.ring(cx + 1, cy + 1, r, shadow)
        canvas.line(cx - r - 1, cy - 2, cx - r + 1, cy - 2, spark)
        canvas.line(cx - r - 1, cy + 2, cx - r + 1, cy + 2, spark)

    elif kind == "twin":
        # 菱形双半：左半高灰度（浅端=金），右半低灰度（深端=蓝）
        rr = max(1, int(round(r)))
        ix, iy = int(round(cx)), int(round(cy))
        for dy in range(-rr, rr + 1):
            half = rr - abs(dy)
            if half == 0:
                continue
            canvas.put(ix - half, iy + dy, spark)
            canvas.put(ix + half, iy + dy, shadow)
        # 中轴（亮）与双点
        canvas.line(ix, iy - rr, ix, iy + rr, line)
        canvas.put(ix - 1, iy - rr + 2, spark)
        canvas.put(ix + 1, iy - rr + 2, shadow)

    elif kind == "stamp":
        canvas.seal(int(round(cx - r)), int(round(cy - r)),
                    int(round(cx + r)), int(round(cy + r)),
                    line, bar_gray=shadow)
        # 纸纹：方框外 2 个纤维点
        canvas.put(cx - r - 1, cy + r, spark)
        canvas.put(cx + r + 1, cy - r, spark)

    else:
        raise ValueError("unknown motif %r" % kind)


def _crest(canvas, kind, roles, seed=0):
    """头盔中脊（sentry 同位 x=11..12）。"""
    line, shadow, spark = roles["line"], roles["shadow"], roles["spark"]
    if kind == "rings":
        canvas.line(11, 0, 11, 7, line)
        canvas.line(10, 2, 12, 2, shadow)
        canvas.line(10, 5, 12, 5, shadow)
    elif kind == "crack":
        canvas.line(11, 0, 12, 3, line)
        canvas.line(12, 3, 10, 6, line)
        canvas.line(11, 7, 12, 8, shadow)
    elif kind == "flower":
        canvas.ring(11.5, 3, 2, line)
        canvas.put(11, 3, spark)
        canvas.put(11, 7, shadow)
    elif kind == "ghost":
        canvas.line(11, 0, 11, 7, line)
        canvas.line(12, 1, 12, 8, shadow)
    elif kind == "twin":
        canvas.line(10, 0, 10, 8, spark)
        canvas.line(12, 0, 12, 8, shadow)
    elif kind == "stamp":
        canvas.rect_outline(9, 1, 13, 5, line)
        canvas.put(11, 3, shadow)


def _band(canvas, kind, x0, y, x1, roles, seed=0):
    """1px 甲带；按套别改变节奏。"""
    line, shadow, spark = roles["line"], roles["shadow"], roles["spark"]
    if kind == "rings":
        canvas.line(x0, y, x1, y, line)
        canvas.line(x0 + 2, y + 1, x1 - 2, y + 1, shadow)
        for x in range(x0 + 3, x1, 4):
            canvas.put(x, y, spark)
    elif kind == "crack":
        canvas.dashed(x0, y, x1, y, line, on=2, off=2)
        canvas.dashed(x0 + 1, y + 1, x1, y + 1, shadow, on=1, off=3)
    elif kind == "flower":
        canvas.dashed(x0, y, x1, y, line, on=1, off=2)
        # 水月：每 5px 一段 2px 浅弧点
        for x in range(x0 + 1, x1 - 1, 5):
            canvas.put(x, y + 1, shadow)
            canvas.put(x + 1, y + 1, shadow)
    elif kind == "ghost":
        canvas.dashed(x0, y, x1 - 1, y, line, on=3, off=2)
        canvas.dashed(x0 + 1, y + 1, x1, y + 1, shadow, on=3, off=2)
    elif kind == "twin":
        mid = (x0 + x1) // 2
        canvas.line(x0, y, mid, y, spark)
        canvas.line(mid + 1, y, x1, y, shadow)
        canvas.line(x0, y + 1, mid, y + 1, shadow)
        canvas.line(mid + 1, y + 1, x1, y + 1, spark)
    elif kind == "stamp":
        for x in range(x0, x1 + 1, 3):
            canvas.line(x, y, min(x + 1, x1), y, line)
        canvas.put(x0, y + 1, shadow)
        canvas.put(x1, y + 1, shadow)


def paint_trim(canvas, set_key, layer):
    """把某一套的母题画到 layer（1=盔/甲/靴，2=腿）上；位置对齐 sentry。"""
    style = SETS[set_key]
    kind = style["motif"]
    roles = style["gray_roles"]
    seed = sum(ord(c) for c in set_key) * 13

    if layer == 1:
        # 盔：盔顶中脊 + 盔顶徽记（不压面甲开口 y11..15）
        _crest(canvas, kind, roles, seed)
        _badge(canvas, kind, 11.5, 3.5, 2.0, roles, seed + 1)
        # 眉线：只占 y9..10，避开眼部
        canvas.line(9, 9, 14, 9, roles["shadow"])
        # 肩：顶面 3×3 徽记 + 上臂环
        _badge(canvas, kind, 45.5, 17.5, 1.6, roles, seed + 2)
        _band(canvas, kind, 40, 22, 55, roles, seed + 3)
        # 胸心：主徽记 r=2.6，落在锁骨下方（避开领口透明区）
        _badge(canvas, kind, 23.5, 26.2, 2.6, roles, seed + 4)
        # 靴踝：绕腿一圈
        _band(canvas, kind, 0, 26, 15, roles, seed + 5)
        # 后脑一条短带（sentry 同位）
        canvas.line(27, 8, 27, 13, roles["shadow"])
        canvas.line(28, 9, 28, 12, roles["line"])
    else:
        # 腿：大腿一圈 + 前腰小徽记
        _band(canvas, kind, 0, 23, 15, roles, seed + 6)
        _badge(canvas, kind, 23.5, 25.0, 2.4, roles, seed + 7)
        # 膝下 1px 断裂带
        _band(canvas, kind, 0, 29, 15, roles, seed + 8)
    return canvas


def build_trim(set_key, layer):
    if set_key not in SETS:
        raise KeyError(set_key)
    c = TrimCanvas(layer)
    paint_trim(c, set_key, layer)
    return c


def palette_image(set_key):
    """8×1 RGB 调色板，索引 0..7 = 深→浅。"""
    if set_key not in SETS:
        raise KeyError(set_key)
    cols = ramp(SETS[set_key]["stops"], 8)
    im = Image.new("RGB", (8, 1))
    px = im.load()
    for i, c in enumerate(cols):
        px[i, 0] = c
    return im


def save_palette(set_key, path):
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    palette_image(set_key).save(path)
    return path


def palette_colors(set_key):
    return [palette_image(set_key).getpixel((i, 0)) for i in range(8)]


def palette_key_image():
    """
    plm 专用 palette_key：8×1，升序 0→224。
    原版 trim_palette 是 224→0；本规范调色板按“深→浅”落盘，
    因此必须配升序 key，才能让 224 映射到最浅色。见规范 §5.4。
    """
    im = Image.new("RGB", (8, 1))
    px = im.load()
    for i, g in enumerate(GRAYS):
        px[i, 0] = (g, g, g)
    return im


def save_palette_key(path):
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    palette_key_image().save(path)
    return path


def atlas_source(namespace="plm"):
    """
    返回追加到 armor_trims.json sources 的 paletted_permutations 片段。
    使用独立 source，保证原版 32 条 pattern × 14 个 material 原样不动。
    """
    textures = []
    for k in SET_ORDER:
        textures.append("%s:trims/models/armor/%s" % (namespace, k))
        textures.append("%s:trims/models/armor/%s_leggings" % (namespace, k))
    return {
        "type": "paletted_permutations",
        "textures": textures,
        "palette_key": "%s:trims/color_palettes/key" % namespace,
        "separator": "_",
        "permutations": {k: "%s:trims/color_palettes/%s" % (namespace, k) for k in SET_ORDER},
    }


# 纹饰灰度 → 调色板索引：使用“升序 key”（0→224）时 index = gray/32。
# 若集成方坚持用原版 trim_palette（224→0）作 key，则 index = 7 - gray/32；
# 本规范统一走升序 plm key，见 §5.4。
def gray_index(gray, ascending_key=True):
    idx = GRAYS.index(gray)
    return idx if ascending_key else 7 - idx


def colorize_trim(trim_img, set_key, ascending_key=True):
    if hasattr(trim_img, "to_image"):
        trim_img = trim_img.to_image()
    cols = palette_colors(set_key)
    out = Image.new("RGBA", trim_img.size, (0, 0, 0, 0))
    src = trim_img.convert("RGBA").load()
    dst = out.load()
    for y in range(trim_img.height):
        for x in range(trim_img.width):
            r, g, b, a = src[x, y]
            if a == 0:
                continue
            idx = gray_index(r, ascending_key)
            dst[x, y] = cols[idx] + (255,)
    return out


def composite(base_img, trim_img, set_key, ascending_key=True):
    """底甲 + 纹饰（纹饰按套别上色），返回 RGBA。"""
    if hasattr(base_img, "to_image"):
        base_img = base_img.to_image()
    out = base_img.convert("RGBA").copy()
    colored = colorize_trim(trim_img, set_key, ascending_key)
    out.alpha_composite(colored)
    return out


# ---------------------------------------------------------------- 纸偶预览


def _face(img, box):
    """按 64×32 逻辑坐标裁正面；返回原生分辨率裁剪。"""
    k = max(1, img.width // 64)
    x, y, w, h = box
    return img.crop((x * k, y * k, (x + w) * k, (y + h) * k))


def paper_doll(layer1, layer2, scale=6, gap=1, bg=(24, 28, 34, 255)):
    """
    用正面 UV 面拼一个 2D 纸偶（头/身/双臂/双腿），只用于预览。
    layer1 提供头/身/臂，layer2 提供腿；左右肢体镜像。
    """
    head = _face(layer1, DOLL_FACES["head"])
    body = _face(layer1, DOLL_FACES["body"])
    arm = _face(layer1, DOLL_FACES["arm"])
    leg = _face(layer2, DOLL_FACES["leg"])
    arm_l = arm.transpose(Image.FLIP_LEFT_RIGHT)
    leg_l = leg.transpose(Image.FLIP_LEFT_RIGHT)

    # 逻辑尺寸（64 坐标）：宽 = 4+8+4 = 16，高 = 1+8+1+12+1+12 = 35
    lw, lh = 16, 35
    out = Image.new("RGBA", (lw * scale + gap * 6, lh * scale + gap * 6), bg)
    ox, oy = gap * 3, gap * 3
    s = scale

    def paste(img, w, h, cx, cy):
        big = img.resize((w * s, h * s), Image.NEAREST)
        # 透明洞（领口/袖口/眼缝）垫一层深色内衬，避免预览里与背景混成“脸”
        under = Image.new("RGBA", big.size, (42, 47, 54, 255))
        under.putalpha(big.getchannel("A"))
        out.alpha_composite(under, (ox + cx * s, oy + cy * s))
        out.alpha_composite(big, (ox + cx * s, oy + cy * s))

    # 头/身/腿之间留 1 逻辑像素空隙，避免平面堆叠看成“脸”
    paste(head, 8, 8, 4, 0)
    paste(body, 8, 12, 4, 9)
    paste(arm, 4, 12, 0, 9)
    paste(arm_l, 4, 12, 12, 9)
    paste(leg, 4, 12, 5, 22)
    paste(leg_l, 4, 12, 9, 22)
    return out


# ---------------------------------------------------------------- 接触表


def contact_sheet(panels, out_path, cols=3, scale=4, title=None, cell_pad=14):
    """panels: [(label, RGBA image), ...]；每格原尺寸 scale 倍 + 标签。"""
    if not panels:
        raise ValueError("empty panels")
    font = _font(14)
    title_font = _font(22, bold=True)
    cell_w = max(im.width for _, im in panels) * scale + cell_pad * 2
    cell_h = max(im.height for _, im in panels) * scale + cell_pad * 2 + 22
    rows = int(math.ceil(len(panels) / float(cols)))
    head = 44 if title else 8
    W = cell_w * cols
    H = head + cell_h * rows + 8
    out = _checker(W, H, 8)
    d = ImageDraw.Draw(out)
    if title:
        d.text((14, 12), title, font=title_font, fill=(238, 246, 252, 255))
    for i, (label, im) in enumerate(panels):
        cx = (i % cols) * cell_w
        cy = head + (i // cols) * cell_h
        d.rectangle([cx + 2, cy + 2, cx + cell_w - 3, cy + cell_h - 3],
                    outline=(70, 82, 96, 255), width=1)
        big = im.convert("RGBA").resize((im.width * scale, im.height * scale), Image.NEAREST)
        out.alpha_composite(big, (cx + cell_pad, cy + cell_pad))
        d.text((cx + cell_pad, cy + cell_pad + big.height + 3), label, font=font,
               fill=(210, 222, 232, 255))
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    out.save(out_path)
    return out_path


# ---------------------------------------------------------------- 自检


def _load_rgba(path):
    return Image.open(path).convert("RGBA")


def audit_trim(path, layer=None, min_cov=None, max_cov=None):
    im = _load_rgba(path)
    errs, warns = [], []
    if im.size != (64, 32):
        errs.append("size %s != (64,32)" % (im.size,))
    if layer is None:
        layer = 2 if im.height == 32 and im.width == 64 else 1
    if min_cov is None:
        min_cov = MIN_TRIM_COVERAGE["leggings" if layer == 2 else "layer_1"]
    if max_cov is None:
        max_cov = MAX_TRIM_COVERAGE["leggings" if layer == 2 else "layer_1"]
    mask = netherite_mask(layer)
    px, mp = im.load(), mask.load()
    visible = 0
    outside = 0
    bad_alpha = 0
    bad_gray = 0
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a not in (0, 255):
                bad_alpha += 1
                continue
            if a == 0:
                continue
            visible += 1
            if r not in GRAY_SET or not (r == g == b):
                bad_gray += 1
            if mp[x, y] == 0:
                outside += 1
    cov = visible / float(im.width * im.height)
    if bad_alpha:
        errs.append("alpha 非二值：%d px" % bad_alpha)
    if bad_gray:
        errs.append("非 trim_palette 灰度：%d px" % bad_gray)
    if outside:
        errs.append("超出 netherite alpha：%d px" % outside)
    if cov > max_cov:
        errs.append("覆盖率 %.2f%% > %.1f%%（铺太满）" % (cov * 100, max_cov * 100))
    if cov < min_cov:
        warns.append("覆盖率 %.2f%% < %.1f%%（可能没画）" % (cov * 100, min_cov * 100))
    return {
        "path": path, "layer": layer, "size": im.size, "visible": visible,
        "coverage": cov, "grays": sorted({px[x, y][0] for y in range(im.height)
                                          for x in range(im.width) if px[x, y][3]}),
        "errors": errs, "warnings": warns, "ok": not errs,
    }


def audit_base(path, layer=None):
    im = _load_rgba(path)
    errs, warns = [], []
    if im.size != (128, 64):
        errs.append("size %s != (128,64)" % (im.size,))
        return {"path": path, "size": im.size, "errors": errs, "ok": False}
    if layer is None:
        layer = 1
    mask = netherite_mask(layer, scale=2)
    px, mp = im.load(), mask.load()
    mismatch = 0
    visible = 0
    for y in range(64):
        for x in range(128):
            a = px[x, y][3]
            m = mp[x, y] > 0
            if (a > 0) != m:
                mismatch += 1
            if a > 0:
                visible += 1
            if a not in (0, 255):
                errs.append("alpha 非二值 (x=%d,y=%d)" % (x, y))
                break
    if mismatch:
        errs.append("alpha 与 netherite 2× 遮罩不一致：%d px" % mismatch)
    # 青色发光检查：只看高彩度（chroma≥48）且蓝绿压红的像素；
    # 镜银本身是低彩度冷灰（chroma≈10–38），不应误判。
    cyan = 0
    pure_white = 0
    for y in range(64):
        for x in range(128):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            chroma = max(r, g, b) - min(r, g, b)
            if chroma >= 48 and b >= r and b >= g:
                cyan += 1
            if (r, g, b) == (255, 255, 255):
                pure_white += 1
    lums = sorted(0.2126 * px[x, y][0] + 0.7152 * px[x, y][1] + 0.0722 * px[x, y][2]
                  for y in range(64) for x in range(128) if px[x, y][3])
    mean_l = sum(lums) / len(lums) if lums else 0.0
    median_l = lums[len(lums) // 2] if lums else 0.0
    p90_l = lums[int(len(lums) * 0.9)] if lums else 0.0
    if visible:
        if cyan / visible > 0.02:
            errs.append("青色像素 %.2f%% > 2%%（禁止大面积青色发光）" % (100.0 * cyan / visible))
        if pure_white / visible > 0.02:
            errs.append("纯白 %.2f%% > 2%%" % (100.0 * pure_white / visible))
        if not (90.0 <= mean_l <= 130.0):
            errs.append("平均亮度 %.1f 不在 90–130" % mean_l)
        if p90_l < 165.0:
            errs.append("p90 亮度 %.1f < 165（太暗/太扁）" % p90_l)
    return {
        "path": path, "layer": layer, "size": im.size, "visible": visible,
        "coverage": visible / (128.0 * 64.0), "cyan": cyan, "pure_white": pure_white,
        "mean_luma": round(mean_l, 1), "median_luma": round(median_l, 1), "p90_luma": round(p90_l, 1),
        "errors": errs, "warnings": warns, "ok": not errs,
    }


def audit_palette(path):
    im = Image.open(path).convert("RGB")
    errs = []
    if im.size != (8, 1):
        errs.append("size %s != (8,1)" % (im.size,))
        return {"path": path, "size": im.size, "errors": errs, "ok": False}
    cols = [im.getpixel((i, 0)) for i in range(8)]
    lums = [luminance(c) for c in cols]
    inversions = [i for i in range(7) if lums[i] > lums[i + 1] + 10]
    if inversions:
        errs.append("亮度未按深→浅排列：index %s" % inversions)
    return {"path": path, "size": im.size, "colors": ["#%02X%02X%02X" % c for c in cols],
            "luminance": [round(v, 1) for v in lums], "errors": errs, "ok": not errs}


# ---------------------------------------------------------------- CLI


def _main(argv=None):
    ap = argparse.ArgumentParser(description="镜中倒影盔甲纹饰画具")
    ap.add_argument("--extract", action="store_true", help="解包参考到 out/trim_ref")
    ap.add_argument("--audit", help="自检一张 PNG")
    ap.add_argument("--kind", choices=("trim", "base", "palette"), default="trim")
    ap.add_argument("--layer", type=int, choices=(1, 2), default=1)
    ap.add_argument("--boxes", action="store_true", help="打印 UV 放置区可用像素数")
    args = ap.parse_args(argv)

    if args.extract:
        extract_references()
    if args.boxes:
        for layer in (1, 2):
            print("layer", layer)
            for k, v in mask_boxes(layer).items():
                print("  %-16s %3d px  zone=%s" % (k, v, ZONES[layer][k]))
    if args.audit:
        fn = {"trim": audit_trim, "base": audit_base, "palette": audit_palette}[args.kind]
        kw = {} if args.kind == "palette" else {"layer": args.layer}
        res = fn(args.audit, **kw)
        print(json.dumps(res, ensure_ascii=False, indent=1))
        return 0 if res["ok"] else 1
    if not (args.extract or args.audit or args.boxes):
        ap.print_help()
    return 0


if __name__ == "__main__":
    sys.exit(_main())
