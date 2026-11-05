# -*- coding: utf-8 -*-
"""
gen_netherite_base —— 《梦回盘灵：镜中倒影》镜甲底甲正式生成器

产物（规范 §3 / §6.1）：
  src/resourcepack/assets/minecraft/textures/models/armor/netherite_layer_1.png  128×64
  src/resourcepack/assets/minecraft/textures/models/armor/netherite_layer_2.png  128×64
  out/trim_base_preview.png                                                      与本体 diamond/iron/gold 并排

硬约束：
  * 128×64 RGBA，alpha 只能 0/255；
  * alpha 逐像素等于 vanilla netherite_layer_* 的 2× 最近邻放大
    （layer_1 = 2796 px，layer_2 = 1088 px），不扩边、不补洞；
  * 只用规范 §3.2 的 9 阶镜银（深→浅），色相为低彩度冷灰，无青色发光；
  * 左上来光、右下压暗；1px 甲片缝 / 铆钉 / 倒角 / 少量镜面反光。

画法要点（比 trim_art.build_base_armor 更“手绘”）：
  * 完整 UV 面表（head/body/arm/leg 的全部可见面），按朝向分配底色；
  * 平甲面 + 左上/右下硬折面 + 2–3 条 1–2px 斜反光（#C9DCE6/#E2EFF5），
    不做整片水平反光带，避免胸甲读成白色围兜/冰甲；
  * 面内 1px 倒角：上/左提亮，下/右压暗；贴轮廓的边缘交给深度暗沿；
  * 4×4 Bayer 抖动 + 逐像素颗粒 + 斜向拉丝，做出打磨金属颗粒；
  * 显式甲片缝、V 形胸线、胸甲中脊硬倒角、腿甲前片纵向分界、铆钉与斜光。

CLI：
  python -I src/tools/art/gen_netherite_base.py            # 生成 + 自检 + 预览
  python -I src/tools/art/gen_netherite_base.py --check     # 只检查现有产物
  python -I src/tools/art/gen_netherite_base.py --no-preview
"""
from __future__ import annotations

import argparse
import math
import os
import sys

from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import trim_art as ta  # noqa: E402

ROOT = ta.PROJECT_ROOT
BASE_DIR = os.path.join(ROOT, "src", "resourcepack", "assets", "minecraft",
                        "textures", "models", "armor")
OUT_L1 = os.path.join(BASE_DIR, "netherite_layer_1.png")
OUT_L2 = os.path.join(BASE_DIR, "netherite_layer_2.png")
PREVIEW = os.path.join(ROOT, "out", "trim_base_preview.png")

# 9 阶镜银（规范 §3.2，深→浅）；颜色一律从这里连续插值，不引入新色相
RAMP = [(0x10, 0x15, 0x1A), (0x1C, 0x25, 0x30), (0x2C, 0x39, 0x44),
        (0x47, 0x59, 0x6A), (0x6E, 0x84, 0x94), (0x9D, 0xB2, 0xBE),
        (0xC9, 0xDC, 0xE6), (0xE2, 0xEF, 0xF5), (0xF4, 0xFB, 0xFF)]
EXACT = [tuple(c) + (255,) for c in RAMP]

# 完整 HumanoidModel 64×32 甲面表（已逐面核对 vanilla netherite alpha：699/272 px 全覆盖）
# (name, x, y, w, h, kind, tone_bias)
#   kind: top(朝上) / front(正面) / side(侧面) / back(背面)
FACES = {
    1: [
        ("head_top",    8,  0, 8,  8, "top",   0.30),
        ("head_right",  0,  8, 8,  8, "side", -0.55),
        ("head_front",  8,  8, 8,  8, "front", 0.10),
        ("head_left",  16,  8, 8,  8, "side", -0.05),
        ("head_back",  24,  8, 8,  8, "back", -0.55),
        ("body_right", 16, 20, 4, 12, "side", -0.55),
        ("body_front", 20, 20, 8, 12, "front", 0.05),
        ("body_left",  28, 20, 4, 12, "side", -0.10),
        ("body_back",  32, 20, 8, 12, "back", -0.50),
        ("arm_top",    44, 16, 4,  4, "top",   0.45),
        ("arm_right",  40, 20, 4, 12, "side", -0.60),
        ("arm_front",  44, 20, 4, 12, "front", 0.00),
        ("arm_left",   48, 20, 4, 12, "side", -0.15),
        ("arm_back",   52, 20, 4, 12, "back", -0.50),
        ("leg_top",     8, 16, 4,  4, "top",   0.35),
        ("leg_right",   0, 20, 4, 12, "side", -0.60),
        ("leg_front",   4, 20, 4, 12, "front", 0.00),
        ("leg_left",    8, 20, 4, 12, "side", -0.15),
        ("leg_back",   12, 20, 4, 12, "back", -0.50),
    ],
    2: [
        ("body_right", 16, 20, 4, 12, "side", -0.55),
        ("body_front", 20, 20, 8, 12, "front", 0.00),
        ("body_left",  28, 20, 4, 12, "side", -0.10),
        ("body_back",  32, 20, 8, 12, "back", -0.50),
        ("leg_top",     4, 16, 4,  4, "top",   0.35),
        ("leg_right",   0, 20, 4, 12, "side", -0.60),
        ("leg_front",   4, 20, 4, 12, "front", 0.00),
        ("leg_left",    8, 20, 4, 12, "side", -0.15),
        ("leg_back",   12, 20, 4, 12, "back", -0.50),
    ],
}

KIND_BASE = {
    1: {"top": 4.95, "front": 4.66, "side": 3.96, "back": 3.50},
    2: {"top": 5.05, "front": 4.88, "side": 4.16, "back": 3.72},
}


# ---------------------------------------------------------------- 噪声/色彩


def _hash(x, y, seed):
    return ta._hash_noise(x, y, seed)


_BAYER4 = ((0, 8, 2, 10), (12, 4, 14, 6), (3, 11, 1, 9), (15, 7, 13, 5))


def ramp_color(t):
    """t ∈ [0,8] 沿 9 阶镜银连续插值；超出即钳位。"""
    t = max(0.0, min(8.0, t))
    i = int(math.floor(t))
    f = t - i
    if i >= 8:
        return EXACT[8]
    a, b = RAMP[i], RAMP[i + 1]
    return (int(round(a[0] + (b[0] - a[0]) * f)),
            int(round(a[1] + (b[1] - a[1]) * f)),
            int(round(a[2] + (b[2] - a[2]) * f)), 255)


def _surface(kind, u, v):
    """甲面明暗（单位：色阶 index）。

    规范 §3.3：大面积平甲面 + 大尺度对角光 + 2–3 条 1–2px 斜反光；
    不做整片水平反光带，避免胸甲读成白色围兜/冰甲。
    """
    s = u * 0.72 + v * 0.28
    if kind == "front":
        # 左上略亮、右下略暗：甲片的两个硬折面
        r = 0.16 * (1.0 - u) + 0.10 * (1.0 - v)
        if s > 0.70:
            r -= 0.55                       # 右下折面（反射暗部）
        elif s < 0.50:
            r += 0.14                       # 左上折面
        # 2–3 条 1–2px 斜反光
        if abs(s - 0.36) <= 0.050:
            r += 0.55                       # 宽 1–2px 的副反光
        if abs(s - 0.58) <= 0.028:
            r += 1.10                       # 1px 主反光
        if abs(s - 0.62) <= 0.028:
            r -= 0.45                       # 主反光旁的硬暗边
        # 最下一段是地面暗反射
        if v > 0.80:
            r -= 0.75
    elif kind == "top":
        r = 0.22 * (1.0 - u) + 0.10 * (1.0 - v)
        if u > 0.66:
            r -= 0.30
        if abs(s - 0.52) <= 0.050:
            r += 0.45                       # 顶盖斜反光
    elif kind == "side":
        r = 0.08 - 0.30 * v
        if v > 0.72:
            r -= 0.45
    else:  # back
        r = -0.22
    return r


def _face_bevel(de, dx0, dx1, dy0, dy1, w, h):
    """面内 1px 倒角：最外圈压成甲片缝，内一圈上/左提亮、下/右压暗。

    窄面（≤4）降幅，避免整条腿变斑马纹。
    """
    scale = 0.75 if (w <= 4 or h <= 4) else 1.0
    if de == 0:
        # 甲片分界线（贴面边），四周统一压暗
        if dy1 == 0 or dx1 == 0:
            return -1.15 * scale
        return -0.95 * scale
    if de == 1:
        if dy0 == 0 and dx0 == 0:
            return 1.20 * scale
        if dy1 == 0 and dx1 == 0:
            return -0.75 * scale
        if dy0 == 0:
            return 0.95 * scale
        if dy1 == 0:
            return -0.60 * scale
        if dx0 == 0:
            return 0.75 * scale
        if dx1 == 0:
            return -0.50 * scale
    return 0.0


def _tone_at(layer, face, x, y, u, v, depth, mask, seed):
    """一个像素的目标色阶（0..8）。"""
    _name, _x0, _y0, fw, fh, kind, bias = face
    t = KIND_BASE[layer][kind] + bias

    # 大尺度对角光（左上亮、右下暗）
    t += 0.24 * (1.0 - (x / 128.0) * 0.62 - (y / 64.0) * 0.38) - 0.12

    # 甲面明暗：平甲面 + 斜折面 + 2–3 条细斜反光
    t += _surface(kind, u, v)

    # 每个面一个稳定的手绘偏差，避免所有甲片同一亮度
    t += (_hash(_x0, _y0, seed + 31) - 0.5) * 0.34

    # 极轻的打磨颗粒（不再用大尺度噪声，保持甲片平整）
    t += (_hash(x, y, seed + 21) - 0.5) * 0.16
    t += (_hash(x // 2, y // 2, seed + 22) - 0.5) * 0.10

    # 斜向拉丝（1px 周期，像手绘笔触）
    phase = (x + y) % 13
    if phase == 0:
        t += 0.22
    elif phase == 1:
        t -= 0.13

    # 面内倒角
    X0, Y0 = _x0 * 2, _y0 * 2
    W, H = fw * 2, fh * 2
    dx0, dx1 = x - X0, X0 + W - 1 - x
    dy0, dy1 = y - Y0, Y0 + H - 1 - y
    de = min(dx0, dx1, dy0, dy1)
    t += _face_bevel(de, dx0, dx1, dy0, dy1, fw, fh)

    # 轮廓暗沿：贴着透明区的 1px 压暗；左上留一点金属厚度
    d = depth[y][x]
    if d == 1:
        up_t = y == 0 or mask.getpixel((x, y - 1)) == 0
        lf_t = x == 0 or mask.getpixel((x - 1, y)) == 0
        dn_t = y == 63 or mask.getpixel((x, y + 1)) == 0
        rt_t = x == 127 or mask.getpixel((x + 1, y)) == 0
        t = 0.68 + 0.30 * _hash(x, y, seed + 5)
        if up_t or lf_t:
            t += 0.55
        if dn_t or rt_t:
            t -= 0.12
    elif d == 2:
        t = t * 0.92 - 0.06

    # 有序抖动：让连续色阶出现打磨颗粒
    t += (_BAYER4[y % 4][x % 4] / 16.0 - 0.5) * 0.26
    return t


# ---------------------------------------------------------------- 覆盖层


def _px(bc, x, y, color):
    bc.put(int(x), int(y), color)


def _line128(bc, pts, color):
    """128 坐标折线（1px）。"""
    for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
        steps = max(abs(x1 - x0), abs(y1 - y0))
        for i in range(steps + 1):
            x = x0 + (x1 - x0) * i / steps if steps else x0
            y = y0 + (y1 - y0) * i / steps if steps else y0
            _px(bc, x, y, color)


def _seam_h(bc, x0, x1, y, width=1, dark=EXACT[0], lip=EXACT[3]):
    """64 坐标水平甲片缝：暗线 1px + 下沿 1px 亮唇。"""
    for x in range(x0 * 2, x1 * 2 + 1):
        if width:
            _px(bc, x, y * 2, dark)
        _px(bc, x, y * 2 + 1, lip)


def _ridge_v(bc, x, y0, y1, light=EXACT[5], dark=EXACT[1]):
    """竖向凸脊：左 1px 受光、右 1px 压暗（光自左上）。"""
    for y in range(y0 * 2, y1 * 2 + 1):
        _px(bc, x * 2, y, light)
        _px(bc, x * 2 + 1, y, dark)


def _rivet(bc, x, y, bright=EXACT[7], crown=EXACT[6], shadow=EXACT[1]):
    """64 坐标 1 逻辑像素铆钉：2×2 亮帽 + 右下 1px 暗影。"""
    X, Y = x * 2, y * 2
    for dx in (0, 1):
        for dy in (0, 1):
            _px(bc, X + dx, Y + dy, crown)
    _px(bc, X, Y, bright)
    _px(bc, X + 2, Y + 1, shadow)
    _px(bc, X + 1, Y + 2, shadow)
    _px(bc, X + 2, Y + 2, shadow)


def _glint(bc, pts64, color=EXACT[8]):
    """64 坐标的 1 逻辑像素斜反光。"""
    pts = [(x * 2, y * 2) for x, y in pts64]
    _line128(bc, pts, color)


def _decorate(bc, layer):
    """显式甲片结构：缝、胸甲 V 线、铆钉、镜面斜光。"""
    if layer == 1:
        # 胸甲中脊：左右各 1px 硬倒角（暗槽 / 亮脊 / 暗侧）
        _ridge_v(bc, 23, 24, 29, light=EXACT[6], dark=EXACT[0])
        for y in range(24 * 2, 29 * 2 + 1):
            _px(bc, 22 * 2, y, EXACT[2])
        _ridge_v(bc, 35, 21, 29, light=EXACT[5], dark=EXACT[0])
        for y in range(21 * 2, 29 * 2 + 1):
            _px(bc, 34 * 2, y, EXACT[2])
        # 腰带横缝 + 胸甲下缘 V 线
        _seam_h(bc, 16, 39, 30)
        _line128(bc, [(20 * 2, 27 * 2), (23 * 2 + 1, 29 * 2), (28 * 2, 27 * 2)], EXACT[0])
        _line128(bc, [(20 * 2, 27 * 2 + 1), (23 * 2 + 1, 29 * 2 + 1), (28 * 2, 27 * 2 + 1)], EXACT[3])
        # 臂环 / 靴口 / 靴踝 / 靴背脊
        _seam_h(bc, 40, 55, 27)
        _seam_h(bc, 0, 15, 24)
        _seam_h(bc, 0, 15, 29)
        _ridge_v(bc, 45, 21, 28, light=EXACT[5], dark=EXACT[1])
        _ridge_v(bc, 5, 25, 31, light=EXACT[5], dark=EXACT[1])
        # 头盔顶中脊 + 眉线 + 下颚线（避开 y9 眉线与 y11..15 面甲开口）
        _ridge_v(bc, 11, 0, 7, light=EXACT[6], dark=EXACT[1])
        _seam_h(bc, 8, 15, 10, dark=EXACT[1], lip=EXACT[5])
        _seam_h(bc, 0, 7, 12)
        _seam_h(bc, 16, 23, 12)
        _seam_h(bc, 24, 31, 12)
        # 铆钉：胸、背、臂、靴（肩顶小盖不钉，避免读成洞）
        for rx, ry in ((21, 21), (26, 21), (21, 25), (26, 25),
                       (33, 22), (38, 22),
                       (41, 23), (54, 23), (1, 22), (13, 22),
                       (9, 9), (14, 9)):
            _rivet(bc, rx, ry)
        # 肩顶盖：1px 横向高光
        _glint(bc, [(45, 17), (46, 17)], EXACT[7])
        # 镜面反光：每层只保留 2–3 条 1px 斜线
        _glint(bc, [(9, 1), (10, 2), (11, 3), (12, 4)])
        _glint(bc, [(9, 1), (9, 2)], EXACT[7])
        _glint(bc, [(20, 21), (21, 22), (22, 23), (23, 24)])
        _glint(bc, [(20, 21), (20, 22)], EXACT[7])
        _glint(bc, [(45, 17), (46, 18)], EXACT[7])
    else:
        # 腿甲：膝/踝 + 前腰中脊
        _seam_h(bc, 0, 15, 27)
        _seam_h(bc, 0, 15, 30)
        _seam_h(bc, 16, 39, 29)
        _ridge_v(bc, 23, 23, 29, light=EXACT[5], dark=EXACT[1])
        _ridge_v(bc, 35, 21, 28, light=EXACT[4], dark=EXACT[1])
        # 前腰 V 线
        _line128(bc, [(20 * 2, 25 * 2), (23 * 2 + 1, 27 * 2), (28 * 2, 25 * 2)], EXACT[0])
        _line128(bc, [(20 * 2, 25 * 2 + 1), (23 * 2 + 1, 27 * 2 + 1), (28 * 2, 25 * 2 + 1)], EXACT[3])
        # 腿前胫脊：硬边纵向分界（左亮右暗，光自左上）
        for lx in (5, 13):
            _ridge_v(bc, lx, 21, 30, light=EXACT[6], dark=EXACT[0])
        for rx, ry in ((1, 22), (14, 22), (1, 27), (14, 27),
                       (1, 29), (14, 29), (21, 22), (26, 22)):
            _rivet(bc, rx, ry)
        # 镜面反光：只保留 3 条 1px 斜线
        _glint(bc, [(21, 21), (22, 22)])
        _glint(bc, [(5, 21), (6, 22), (6, 23)])
        _glint(bc, [(1, 23), (1, 24)], EXACT[7])


# ---------------------------------------------------------------- 生成


def build(layer, seed=20261103):
    bc = ta.BaseCanvas(layer)
    mask = bc.mask
    depth = ta._depth_map(mask)
    face_map = [[-1] * 64 for _ in range(32)]
    for idx, (_n, x0, y0, w, h, _k, _b) in enumerate(FACES[layer]):
        for yy in range(y0, y0 + h):
            for xx in range(x0, x0 + w):
                face_map[yy][xx] = idx
    faces = FACES[layer]
    for y in range(64):
        for x in range(128):
            if mask.getpixel((x, y)) == 0:
                continue
            idx = face_map[y // 2][x // 2]
            if idx < 0:
                continue
            face = faces[idx]
            _n, x0, y0, w, h, _k, _b = face
            u = (x - x0 * 2 + 0.5) / (w * 2)
            v = (y - y0 * 2 + 0.5) / (h * 2)
            t = _tone_at(layer, face, x, y, u, v, depth, mask, seed)
            bc.put(x, y, ramp_color(t))
    _decorate(bc, layer)
    # 装饰层可能写到遮罩外？BaseCanvas.put 已裁；alpha 仍为二值
    return bc


def save_layer(bc, path):
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    bc.im.save(path)
    return path


# ---------------------------------------------------------------- 预览


def _make_preview(scale=4):
    panels = []
    for layer, tag in ((1, "L1"), (2, "L2")):
        for label, path in (
            ("镜甲 %s（本 DLC）" % tag, OUT_L1 if layer == 1 else OUT_L2),
            ("diamond %s（本体）" % tag,
             os.path.join(ROOT, "out", "trim_ref", "panling", "diamond_layer_%d.png" % layer)),
            ("iron %s（本体）" % tag,
             os.path.join(ROOT, "out", "trim_ref", "panling", "iron_layer_%d.png" % layer)),
            ("gold %s（本体）" % tag,
             os.path.join(ROOT, "out", "trim_ref", "panling", "gold_layer_%d.png" % layer)),
        ):
            panels.append((label, Image.open(path).convert("RGBA")))
    font = ta._font(15)
    small = ta._font(13)
    title_font = ta._font(24, bold=True)
    pad = 16
    cell_w = 128 * scale + pad * 2
    cell_h = 64 * scale + pad * 2 + 24
    cols, rows = 4, 2
    head = 60
    foot = 26
    W = cell_w * cols + 8
    H = head + cell_h * rows + foot
    # 中性灰棋盘：比深色底更能看出银灰的金属层次
    out = Image.new("RGBA", (W, H), (74, 78, 84, 255))
    d = ImageDraw.Draw(out)
    for yy in range(0, H, 8):
        for xx in range(0, W, 8):
            if ((xx // 8) + (yy // 8)) % 2 == 0:
                d.rectangle([xx, yy, xx + 7, yy + 7], fill=(82, 86, 92, 255))
    d.text((16, 14), "镜甲底甲 128×64 · 与本体 diamond / iron / gold 并排（%d×）" % scale,
           font=title_font, fill=(240, 246, 252, 255))
    for i, (label, im) in enumerate(panels):
        cx = (i % cols) * cell_w + 4
        cy = head + (i // cols) * cell_h
        d.rectangle([cx + 1, cy + 1, cx + cell_w - 2, cy + cell_h - 2],
                    outline=(96, 104, 114, 255), width=1)
        big = im.resize((im.width * scale, im.height * scale), Image.NEAREST)
        out.alpha_composite(big, (cx + pad, cy + pad))
        d.text((cx + pad, cy + pad + big.height + 4), label, font=font,
               fill=(232, 240, 246, 255))
    d.text((16, H - foot + 4),
           "RGBA 128×64 · alpha 严格等于 vanilla netherite_layer_* 的 2×（L1 2796 px / L2 1088 px）",
           font=small, fill=(210, 220, 230, 255))
    os.makedirs(os.path.dirname(PREVIEW), exist_ok=True)
    out.save(PREVIEW)
    return PREVIEW


# ---------------------------------------------------------------- 自检

CHECKS = []


def _record(ok, text):
    ok = bool(ok)
    CHECKS.append((ok, text))
    print(("PASS  " if ok else "FAIL  ") + text)
    return ok


def check_layer(path, layer):
    ok_all = True
    if not os.path.exists(path):
        _record(False, "缺少 %s" % path)
        return False
    im = Image.open(path)
    ok_all &= _record(im.size == (128, 64), "%s 尺寸 %s == (128,64)" % (os.path.basename(path), im.size))
    ok_all &= _record(im.mode == "RGBA", "%s 模式 %s == RGBA" % (os.path.basename(path), im.mode))
    im = im.convert("RGBA")
    px = im.load()
    vanilla = ta.netherite_mask(layer, scale=2)
    vp = vanilla.load()
    mismatch = semi = visible = 0
    for y in range(64):
        for x in range(128):
            a = px[x, y][3]
            if a not in (0, 255):
                semi += 1
            if (a > 0) != (vp[x, y] > 0):
                mismatch += 1
            if a > 0:
                visible += 1
    expect = 2796 if layer == 1 else 1088
    ok_all &= _record(semi == 0, "%s alpha 仅 0/255（半透明 %d px）" % (os.path.basename(path), semi))
    ok_all &= _record(mismatch == 0, "%s alpha 与 vanilla netherite 2× 逐像素一致（mismatch=%d）"
                      % (os.path.basename(path), mismatch))
    ok_all &= _record(visible == expect, "%s 不透明像素 %d == %d" % (os.path.basename(path), visible, expect))
    res = ta.audit_base(path, layer)
    ok_all &= _record(res["ok"], "%s trim_art.audit_base：mean=%.1f median=%.1f p90=%.1f cyan=%d white=%d errors=%s"
                      % (os.path.basename(path), res["mean_luma"], res["median_luma"], res["p90_luma"],
                         res["cyan"], res["pure_white"], res["errors"] or "[]"))
    # 细节密度：唯一 RGB 数（本体 263–513，避免“压到 20 色”）
    uniq = len({px[x, y][:3] for y in range(64) for x in range(128) if px[x, y][3]})
    ok_all &= _record(uniq >= 160, "%s 唯一 RGB %d ≥ 160（细节密度）" % (os.path.basename(path), uniq))
    # 镜银族检查：全部像素落在 9 阶 ramp 的色域包络内（低彩度冷灰）
    chroma_max = max(max(px[x, y][:3]) - min(px[x, y][:3])
                     for y in range(64) for x in range(128) if px[x, y][3])
    ok_all &= _record(chroma_max <= 48, "%s 最大彩度 %d ≤ 48（镜银低彩度）" % (os.path.basename(path), chroma_max))
    return ok_all


def run_checks():
    CHECKS.clear()
    ok = True
    ok &= check_layer(OUT_L1, 1)
    ok &= check_layer(OUT_L2, 2)
    if os.path.exists(PREVIEW):
        pim = Image.open(PREVIEW)
        ok &= _record(pim.size[0] >= 2000 and pim.size[1] >= 500,
                      "预览 %s %s，含 4 列 ×2 行" % (os.path.basename(PREVIEW), pim.size))
    else:
        ok &= _record(False, "缺少预览 %s" % PREVIEW)
    return ok


# ---------------------------------------------------------------- CLI


def main(argv=None):
    ap = argparse.ArgumentParser(description="生成镜甲底甲 netherite_layer_1/2（128×64）")
    ap.add_argument("--check", action="store_true", help="只检查现有产物")
    ap.add_argument("--no-preview", action="store_true", help="不生成预览")
    ap.add_argument("--seed", type=int, default=20261103)
    args = ap.parse_args(argv)

    if not args.check:
        for layer, path in ((1, OUT_L1), (2, OUT_L2)):
            bc = build(layer, args.seed)
            save_layer(bc, path)
            print("write %s" % os.path.relpath(path, ROOT))
        if not args.no_preview:
            print("write %s" % os.path.relpath(_make_preview(), ROOT))
    ok = run_checks()
    print("result %s" % ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
