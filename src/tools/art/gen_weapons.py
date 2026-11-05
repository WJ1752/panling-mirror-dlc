# -*- coding: utf-8 -*-
"""gen_weapons.py —— 《梦回盘灵：镜中倒影》武器组 14 张贴图生成器。

产出（严格按 manifest.json 的 texture_root 落盘）：
  src/resourcepack/assets/panling/textures/item/mirror_sword7.png
  ... 共 14 张：剑 1 / 斧 1 / 弓 4 / 弩 6 / 双生炉 1 / 拓印炉 1
  out/art/sheet_weapons.png   4× 接触表 + 底部 16×16 实际尺寸复核行

设计口径（见《镜中倒影_美术规范_v1.0.md》）：
  * 64×64 RGBA、透明底、alpha 二值、硬边、≤20 色；
  * 最外圈透明，描边占 1..62，主体占 2..61；
  * 外描边 #14181D、镜银主色阶、六套强调色、左上光源；
  * 同一武器的 static / pulling / arrow / firework 共用同一套几何函数，
    只位移「弦 / 弓臂 / 箭」，不换主体结构、不换色。

拉弓/装填态的派生方式：
  draw_bow(state) 与 draw_crossbow(state) 共用同一个几何构造器；static 是
  d=0 的原型，pulling_* 只改三个状态量：
    1) 弦顶点沿「远离弓臂」的法向位移 d（弓 3.5/8.0/12.5px，弩 4.0/8.5/12.0px）；
    2) 弓臂控制点向弦侧收拢（弓 0→24%，弩前拱 5.5→1.5px）；
    3) 臂端沿弦的反向回缩（弓 0→1.8px、弩 0→2.4px）。
  因此整体轮廓仍落在同一区域（static 像素 ±5px 覆盖 99.7–100%），
  但弦和臂的位移肉眼可辨。

用法：
  python -I src/tools/art/gen_weapons.py
  python -I src/tools/art/gen_weapons.py --check-only   # 只重跑自检，不重画
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import sys

from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import mirror_art as ART
from mirror_art import (Canvas, ICON_SIZE, MIRROR, SET_STYLE, bezier,
                        contact_sheet, petal_flower, style_acc, style_dark)

MANIFEST_PATH = os.path.join(HERE, 'manifest.json')
SHEET_PATH = os.path.join(ROOT, 'out', 'art', 'sheet_weapons.png')

# 与 manifest / 美术规范 §6.4 §6.5 一致的状态位移表
BOW_PULL = {'static': 0.0, 'pulling_0': 3.5, 'pulling_1': 8.0, 'pulling_2': 12.5}
XBOW_PULL = {'static': 0.0, 'pulling_0': 4.0, 'pulling_1': 8.5,
             'pulling_2': 12.0, 'arrow': 0.0, 'firework': 0.0}
BOW_STATES = ('static', 'pulling_0', 'pulling_1', 'pulling_2')
XBOW_STATES = ('static', 'pulling_0', 'pulling_1', 'pulling_2', 'arrow', 'firework')


# ---------------------------------------------------------------- 弓（4 态）

def draw_bow(style, state='static'):
    """镜花境弓：反曲臂 + 花瓣臂端 + 1px 弦；拉弓态由同一几何派生。"""
    c = Canvas()
    d = BOW_PULL.get(state, 0.0)
    k = d / 12.5

    S0, E0, C0 = (12.0, 54.0), (52.0, 12.0), (16.0, 12.0)
    mx0, my0 = (S0[0] + E0[0]) / 2.0, (S0[1] + E0[1]) / 2.0
    nx, ny = -(E0[1] - S0[1]), (E0[0] - S0[0])
    nl = math.hypot(nx, ny)
    nx, ny = nx / nl, ny / nl          # 指向弦的外侧（远离弓臂）

    # 拉弓：臂端向弦侧回缩 0→1.8px，控制点向弦收拢 0→24%
    shift = 1.8 * k
    S = (S0[0] + nx * shift, S0[1] + ny * shift)
    E = (E0[0] + nx * shift, E0[1] + ny * shift)
    C = (C0[0] + (mx0 - C0[0]) * 0.24 * k,
         C0[1] + (my0 - C0[1]) * 0.24 * k)

    curve = bezier(S, C, E, 34)
    body = c.polyline(curve, MIRROR[2], 4)
    c.polyline([(x - 1.0, y - 1.0) for x, y in curve], MIRROR[1], 1)

    # 臂端花瓣（镜花母题唯一识别点）
    for tx, ty in (S, E):
        petal_flower(c, tx, ty, 5.0, style_acc(style, 0), style_acc(style, 1), 5)
        c.put(int(tx), int(ty), style_acc(style, 0))

    # 弦：static 为直线，pulling 为向弓臂外侧顶出的 V
    mx, my = (S[0] + E[0]) / 2.0, (S[1] + E[1]) / 2.0
    vx, vy = mx + nx * d, my + ny * d
    c.line(S[0], S[1], vx, vy, MIRROR[0], 1)
    c.line(vx, vy, E[0], E[1], MIRROR[0], 1)

    if d > 0:
        _bow_arrow(c, style, (vx, vy), (nx, ny), d)

    # 握把（曲线中点，随臂一起位移）
    gx, gy = curve[len(curve) // 2]
    c.circle(gx, gy, 4.0, MIRROR[4])
    c.circle(gx, gy, 3.0, style_acc(style, 0), fill=False)
    c.put(int(gx) - 1, int(gy) - 1, MIRROR[0])

    ART._finish(c, shade_mask=body, highlight_mask=None)
    return c


def _bow_arrow(c, style, v, n, d):
    """搭在弦上的箭：尾羽留在弦顶点，箭镞穿向弓身（左上）。"""
    nx, ny = -n[0], -n[1]              # 指向弓身/目标，而不是射手方向
    px, py = -ny, nx
    length = 5.5 + 7.5 * (d / 12.5)    # pulling_0 短箭，pulling_2 满箭
    tail = (v[0] + nx * 1.2, v[1] + ny * 1.2)
    tip = (v[0] + nx * length, v[1] + ny * length)
    c.line(tail[0], tail[1], tip[0], tip[1], style_dark(style), 1)
    c.poly([(tip[0] + nx * 3.5, tip[1] + ny * 3.5),
            (tip[0] - px * 2.4, tip[1] - py * 2.4),
            (tip[0] + px * 2.4, tip[1] + py * 2.4)], style_acc(style, 1))
    bx, by = v[0] + nx * 3.0, v[1] + ny * 3.0
    for s in (-1, 1):
        c.line(bx, by, bx - nx * 2.2 + px * 2.2 * s,
               by - ny * 2.2 + py * 2.2 * s, style_acc(style, 0), 1)


# ---------------------------------------------------------------- 弩（6 态）

def _translate(c, dx, dy):
    """整张画布平移（保留 body 集合与描边），用于把弩主体移回画布中心附近。"""
    out = Canvas()
    for y in range(c.h):
        for x in range(c.w):
            px = c.get(x, y)
            if px[3] == 0:
                continue
            out.put(x + dx, y + dy, px, body=(x, y) in c.body)
    return out

def draw_crossbow(style, state='static'):
    """残影镜弩：弩身 + 双弓臂 + 镜弩机 + 残影副轮廓；六态同源。"""
    c = Canvas()
    d = XBOW_PULL.get(state, 0.0)
    k = d / 12.0

    butt, nose = (22.0, 58.0), (46.0, 34.0)
    ux, uy = 0.72, -0.694
    ln = math.hypot(ux, uy)
    ux, uy = ux / ln, uy / ln          # 弩身指向（左下→右上）
    px, py = -uy, ux

    # 残影副轮廓 / 速度线（先画，主体压在上面）
    c.line(butt[0] + 3, butt[1] + 3, nose[0] + 3, nose[1] + 3, style_acc(style, 1), 1)
    for off in (4, 7):
        c.line(butt[0] - off, butt[1] + 1,
               butt[0] - off + 6 * ux, butt[1] + 1 + 6 * uy,
               style_acc(style, 1), 1)

    # 弩身 + 3 道青色缠带
    c.line(butt[0], butt[1], nose[0], nose[1], MIRROR[4], 8)
    c.line(butt[0] - 1, butt[1] - 1, nose[0] - 1, nose[1] - 1, MIRROR[3], 1)
    for t in (0.20, 0.44, 0.68):
        cx = butt[0] + (nose[0] - butt[0]) * t
        cy = butt[1] + (nose[1] - butt[1]) * t
        c.line(cx - px * 2.2, cy - py * 2.2, cx + px * 2.2, cy + py * 2.2,
               style_acc(style, 0), 1)

    # 弓臂几何：臂端固定，拉弦只改前拱（10.5→3.0px）；
    # 两端取 (35,23)/(57,45)：弦为精确 45°（y=x-12），64→16 最近邻能连续采到 1px 白弦。
    arch = 10.5 - 6.5 * k
    arm_b = (35.0, 23.0)
    arm_a = (57.0, 45.0)
    mount = ((arm_b[0] + arm_a[0]) / 2.0, (arm_b[1] + arm_a[1]) / 2.0)
    ctrl_a = ((arm_a[0] + nose[0]) / 2 + ux * 2 * arch,
              (arm_a[1] + nose[1]) / 2 + uy * 2 * arch)
    ctrl_b = ((arm_b[0] + nose[0]) / 2 + ux * 2 * arch,
              (arm_b[1] + nose[1]) / 2 + uy * 2 * arch)
    curve_a = bezier(nose, ctrl_a, arm_a, 18)
    curve_b = bezier(arm_b, ctrl_b, nose, 18)

    # 残影副臂（与上侧弓臂平行、偏移 4px）
    c.line(arm_b[0] + 4, arm_b[1] + 4, nose[0] + 4, nose[1] + 4, style_acc(style, 1), 1)

    # 镜弩机：青环 + 深青盘 + 白点（16×16 下仍是一枚青盘而不是白点）
    c.circle(32, 48, 7.0, style_acc(style, 0))
    c.circle(32, 48, 5.6, style_acc(style, 1))
    c.circle(32, 48, 2.2, MIRROR[0])

    # 弓臂 + 左上 1px 高光 + 臂端青帽
    arm = c.polyline(curve_b, MIRROR[2], 8) | c.polyline(curve_a, MIRROR[2], 8)
    c.polyline([(x - 2.5, y - 2.5) for x, y in curve_b[:12]], MIRROR[1], 1)
    c.polyline([(x - 2.5, y - 2.5) for x, y in curve_a[6:]], MIRROR[1], 1)
    c.circle(arm_a[0], arm_a[1], 2.6, style_acc(style, 0))
    c.circle(arm_b[0], arm_b[1], 2.6, style_acc(style, 0))

    # 弦：压在镜弩机与臂端之上，1px 白弦；static 为 45° 直线，16×16 可连续采样
    vx = mount[0] - ux * d
    vy = mount[1] - uy * d
    c.line(arm_b[0], arm_b[1], vx, vy, MIRROR[0], 1)
    c.line(vx, vy, arm_a[0], arm_a[1], MIRROR[0], 1)

    # 箭 / 烟花：箭杆压在镜弩机上，头伸到弩头右上空档（16×16 需 ≥2×2 高对比块）
    if state in ('arrow', 'firework'):
        tip = (53.0, 27.0)
        c.line(32.0, 48.0, tip[0], tip[1], style_acc(style, 1), 6)
        c.line(32.0, 48.0, tip[0], tip[1], MIRROR[1], 2)
        if state == 'arrow':
            c.poly([(tip[0] + ux * 11.0, tip[1] + uy * 11.0),
                    (tip[0] - ux * 6.0 + px * 9.5, tip[1] - uy * 6.0 + py * 9.5),
                    (tip[0] - ux * 6.0 - px * 9.5, tip[1] - uy * 6.0 - py * 9.5)], style_acc(style, 1))
            c.poly([(tip[0] + ux * 9.0, tip[1] + uy * 9.0),
                    (tip[0] - ux * 5.0 + px * 6.5, tip[1] - uy * 5.0 + py * 6.5),
                    (tip[0] - ux * 5.0 - px * 6.5, tip[1] - uy * 5.0 - py * 6.5)], style_acc(style, 0))
            c.poly([(tip[0] + ux * 7.0, tip[1] + uy * 7.0),
                    (tip[0] - ux * 4.0 + px * 5.0, tip[1] - uy * 4.0 + py * 5.0),
                    (tip[0] - ux * 4.0 - px * 5.0, tip[1] - uy * 4.0 - py * 5.0)], MIRROR[0])
        for i in range(6):
            bx, by = 34.0 + i * 2.0, 46.0 - i * 2.0
            c.line(bx - px * 5, by - py * 5, bx + px * 5, by + py * 5,
                   style_acc(style, 1), 1)
        c.rect(34, 44, 40, 50, style_acc(style, 0))

    # 烟花弹：青盘 + 白心 + 4 个十字火花（不引入套装外的品红）
    if state == 'firework':
        tip = (53.0, 27.0)
        c.circle(tip[0], tip[1], 8.0, style_acc(style, 0))
        c.circle(tip[0], tip[1], 3.4, MIRROR[0])
        for dx, dy in ((6, 0), (0, 6), (-6, 6), (5, -5)):
            fx, fy = int(tip[0] + dx), int(tip[1] + dy)
            c.line(fx - 2, fy, fx + 2, fy, style_acc(style, 0), 1)
            c.line(fx, fy - 2, fx, fy + 2, style_acc(style, 0), 1)

    ART._finish(c, shade_mask=arm, highlight_mask=None)
    return _translate(c, -2, -2)


# ---------------------------------------------------------------- 静态四把

def draw_twin_furnace(style):
    """双生镜炉：沿用画具原型，只把中央镜菱重绘为左金右蓝双半（§6.6-5/§5.4）。"""
    c = ART.draw_twin_furnace(style)
    scratch = Canvas()
    dia = scratch.poly([(32, 9), (40, 18), (32, 27), (24, 18)], MIRROR[2])
    for x, y in dia:
        c.put(x, y, style_acc(style, 0) if x < 32 else style_acc(style, 1))
    for y in range(9, 28):
        c.put(32, y, MIRROR[0])
    return c


def draw_weapon(entry):
    """按 manifest 条目绘制一把武器。"""
    style = SET_STYLE[entry['set']]
    builder = entry['builder']
    if builder == 'sword':
        return ART.draw_sword(style)
    if builder == 'axe':
        return ART.draw_axe(style)
    if builder == 'bow':
        return draw_bow(style, entry['state'])
    if builder == 'crossbow':
        return draw_crossbow(style, entry['state'])
    if builder == 'twin_furnace':
        return draw_twin_furnace(style)
    if builder == 'rub_furnace':
        return ART.draw_rub_furnace(style)
    raise ValueError('unknown weapon builder: %r' % builder)


# ---------------------------------------------------------------- 生成 / 自检

def load_weapon_entries():
    with open(MANIFEST_PATH, 'r', encoding='utf-8') as fh:
        manifest = json.load(fh)
    entries = [e for e in manifest['entries'] if e.get('kind') == 'weapon']
    if len(entries) != 14:
        raise SystemExit('manifest 武器条目应为 14，实际 %d' % len(entries))
    for e in entries:
        if e['builder'] == 'bow':
            allowed = BOW_STATES
        elif e['builder'] == 'crossbow':
            allowed = XBOW_STATES
        else:
            allowed = ('static',)
        if e['state'] not in allowed:
            raise SystemExit('%s 的 state=%r 不在 %r 内' % (e['key'], e['state'], allowed))
    texture_root = manifest['texture_root']
    out_dir = os.path.join(ROOT, manifest['resourcepack_root'], *texture_root.split('/'))
    return manifest, entries, out_dir


def generate(entries, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    written = []
    for entry in entries:
        canvas = draw_weapon(entry)
        path = os.path.join(out_dir, os.path.basename(entry['texture']))
        canvas.save(path)
        written.append((entry, path))
    return written


def _alpha_bbox(im):
    return im.getchannel('A').getbbox()


def _sha(im):
    return hashlib.sha256(im.tobytes()).hexdigest()


def _alpha_set(im):
    px = im.load()
    return {(x, y) for y in range(im.size[1]) for x in range(im.size[0]) if px[x, y][3] > 0}


def _iou_pair(a, b):
    sa, sb = _alpha_set(a), _alpha_set(b)
    return len(sa & sb) / float(len(sa | sb)), len(sa ^ sb)


def _dilate(mask, radius):
    out = set()
    for x, y in mask:
        for dx in range(-radius, radius + 1):
            for dy in range(-radius, radius + 1):
                out.add((x + dx, y + dy))
    return out


def _cover(src, dst, radius=5):
    """src 有多少比例的像素落在 dst 的 ±radius 邻域内（细长武器的同源判据）。"""
    if not src:
        return 1.0
    near = _dilate(dst, radius)
    return sum(1 for p in src if p in near) / float(len(src))


def _small_diff(a, b, size=16):
    """64→16 最近邻后的像素差（审读用的 GUI 尺寸口径）。"""
    sa = a.resize((size, size), Image.NEAREST)
    sb = b.resize((size, size), Image.NEAREST)
    pa, pb = sa.load(), sb.load()
    return sum(1 for y in range(size) for x in range(size) if pa[x, y] != pb[x, y])


def self_check(entries, out_dir, written):
    rows = []
    errors = []
    seen = {}
    for entry, path in written:
        if os.path.basename(entry['texture']) != entry['key'] + '.png':
            errors.append('%s 的 manifest texture 路径与 key 不一致' % entry['key'])
        if os.path.dirname(os.path.abspath(path)) != os.path.abspath(out_dir):
            errors.append('%s 未落在 manifest.texture_root' % entry['key'])
        im = Image.open(path)
        name = os.path.basename(path)
        if im.size != (ICON_SIZE, ICON_SIZE):
            errors.append('%s 尺寸 %r != 64x64' % (name, im.size))
        if im.mode != 'RGBA':
            errors.append('%s mode=%s != RGBA' % (name, im.mode))
        im = im.convert('RGBA')
        bbox = _alpha_bbox(im)
        if bbox is None:
            errors.append('%s 全透明' % name)
            continue
        if bbox[0] < 1 or bbox[1] < 1 or bbox[2] > ICON_SIZE - 1 or bbox[3] > ICON_SIZE - 1:
            errors.append('%s alpha bbox %r 越过 1px 透明边' % (name, bbox))
        audit = ART.audit_icon_file(path)
        if not audit['ok']:
            errors.append('%s audit: %s' % (name, '; '.join(audit['errors'])))
        if audit['opaque_pixels'] < 200:
            errors.append('%s 不透明像素 %d < 200' % (name, audit['opaque_pixels']))
        digest = _sha(im)
        if digest in seen:
            errors.append('%s 与 %s 完全重复' % (name, seen[digest]))
        seen[digest] = name
        rows.append({
            'name': name, 'key': entry['key'], 'cmd': entry['cmd'],
            'state': entry['state'], 'bbox': bbox, 'audit': audit,
        })

    # 状态派生自检：同一武器的状态必须「有位移」且「仍是同一轮廓」
    family = {}
    for row in rows:
        cat = row['key'].split('_pulling')[0].split('_arrow')[0].split('_firework')[0]
        family.setdefault(cat, []).append(row)
    state_report = []
    pair_report = []
    for cat, members in family.items():
        if len(members) < 2:
            continue
        base = [m for m in members if m['state'] == 'static'][0]
        base_im = Image.open(os.path.join(out_dir, base['name'])).convert('RGBA')
        for m in members:
            if m is base:
                continue
            im = Image.open(os.path.join(out_dir, m['name'])).convert('RGBA')
            iou, diff = _iou_pair(base_im, im)
            # 细长武器（弓臂 4px）位移 3-12px 时 IoU 天然很低；改用「static 的像素
            # 是否都落在状态图的 ±5px 邻域」判定同源，另加 bbox 变化上限。
            cover = _cover(_alpha_set(base_im), _alpha_set(im), 5)
            bb0, bb1 = base_im.getchannel('A').getbbox(), im.getchannel('A').getbbox()
            bbox_delta = max(abs(bb0[i] - bb1[i]) for i in range(4))
            gui16 = _small_diff(base_im, im)
            state_report.append((cat, m['state'], diff, iou, cover, bbox_delta, gui16))
            if diff < 20:
                errors.append('%s/%s 与 static 几乎无位移（仅 %d px 差异）' % (cat, m['state'], diff))
            if cover < 0.98:
                errors.append('%s/%s static 轮廓仅 %.1f%% 落在 ±5px 邻域，疑换形'
                              % (cat, m['state'], cover * 100))
            if bbox_delta > 6:
                errors.append('%s/%s 与 static 的 bbox 偏移 %dpx 过大' % (cat, m['state'], bbox_delta))
            if cat == 'mirror_crossbow7' and m['state'] in ('arrow', 'firework') and gui16 < 4:
                errors.append('%s/%s 在 16×16 下与 static 仅差 %d px，GUI 尺寸不可辨'
                              % (cat, m['state'], gui16))
        by_state = {m['state']: m for m in members}
        if 'arrow' in by_state and 'firework' in by_state:
            ia = Image.open(os.path.join(out_dir, by_state['arrow']['name'])).convert('RGBA')
            ib = Image.open(os.path.join(out_dir, by_state['firework']['name'])).convert('RGBA')
            pair = _small_diff(ia, ib)
            pair_report.append((cat, pair))
            if pair < 4:
                errors.append('%s arrow/firework 在 16×16 下仅差 %d px' % (cat, pair))
    return rows, state_report, pair_report, errors




def _append_16_preview(sheet_path, items, cols=14, tile=96, gap=8, pad=24):
    """在 4× 接触表底部追加 16×16 实际尺寸预览（最近邻放大），供 GUI 可读性复核。

    做法与 gen_materials.py 的 16×16 复核行一致：每张先缩到 16×16，再最近邻放大。
    """
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
           font=ART.font(16, True), fill=(232, 239, 244, 255))
    for i, (path, label) in enumerate(items):
        r, c = divmod(i, cols)
        x = pad + c * (tile + gap)
        y = y0 + title_h + r * (tile + label_h + gap)
        im = Image.open(path).convert('RGBA').resize((16, 16), Image.NEAREST)
        im = im.resize((tile, tile), Image.NEAREST)
        cell = ART.checker_board(tile, tile, 12)
        cell.alpha_composite(im, (0, 0))
        out.alpha_composite(cell, (x, y))
        d.rectangle([x, y, x + tile - 1, y + tile - 1], outline=(58, 70, 84, 255), width=1)
        d.text((x + 1, y + tile + 2), label, font=ART.font(11), fill=(180, 198, 212, 255))
    out.save(sheet_path)
    return sheet_path

def print_report(rows, state_report, pair_report, errors, out_dir):
    print('[dir] %s' % out_dir)
    for row in rows:
        a = row['audit']
        print('  %-34s CMD %-3s %-10s %dx%d RGBA colors=%2d opaque=%4d bbox=%s'
              % (row['name'], row['cmd'], row['state'], a['size'][0], a['size'][1],
                 a['colors'], a['opaque_pixels'], row['bbox']))
    print('[count] %d 张；唯一像素 %d 组' % (len(rows), len({_sha(Image.open(os.path.join(out_dir, r['name'])).convert('RGBA')) for r in rows})))
    for cat, state, diff, iou, cover, bbox_delta, gui16 in state_report:
        print('[state] %-10s %-10s diff=%4d px  IoU=%.3f  static轮廓覆盖=%.1f%%  bboxΔ=%dpx  gui16=%2d/256'
              % (cat, state, diff, iou, cover * 100, bbox_delta, gui16))
    for cat, pair in pair_report:
        print('[gui16] %-10s arrow<->firework %2d/256' % (cat, pair))
    if errors:
        print('[FAIL]')
        for e in errors:
            print('  ! ' + e)
    else:
        print('[PASS] 尺寸/RGBA/1px 边距/alpha/20 色/≥200 像素/无重复/状态派生 全部通过')
    return 0 if not errors else 1


def main():
    ap = argparse.ArgumentParser(description='生成武器组 14 张贴图与 4× 接触表')
    ap.add_argument('--check-only', action='store_true', help='不重画，只对已落盘文件做自检')
    args = ap.parse_args()

    manifest, entries, out_dir = load_weapon_entries()
    if args.check_only:
        written = [(e, os.path.join(out_dir, os.path.basename(e['texture']))) for e in entries]
    else:
        written = generate(entries, out_dir)

    rows, state_report, pair_report, errors = self_check(entries, out_dir, written)
    if not args.check_only:
        sheet_entries = []
        for row in rows:
            sheet_entries.append({
                'path': os.path.join(out_dir, row['name']),
                'label': row['key'],
                'sub': '%s · CMD %s' % (row['state'], row['cmd']),
            })
        contact_sheet(sheet_entries, SHEET_PATH, cols=5, scale=4,
                      title='镜中倒影 · 武器 14 张（4×）')
        _append_16_preview(
            SHEET_PATH,
            [(os.path.join(out_dir, row['name']),
              row['key'].replace('mirror_', '').replace('crossbow7', 'xbow7'))
             for row in rows],
            cols=14, tile=96)
        sheet_im = Image.open(SHEET_PATH)
        print('[sheet] %s  %dx%d' % (SHEET_PATH, sheet_im.size[0], sheet_im.size[1]))
    return print_report(rows, state_report, pair_report, errors, out_dir)


if __name__ == '__main__':
    raise SystemExit(main())
