# -*- coding: utf-8 -*-
"""
gen_sample —— 生成两张验收用样例：

  out/art/sample_sword.png   照心镜剑，64×64 RGBA
  out/art/style_sheet.png    调色板 + 六套色卡 + 样例剑（含 1× / 16×16 预览）

运行：
  python src/tools/art/gen_sample.py

不写 src/resourcepack；所有产物只落 out/art/。
"""
from __future__ import annotations

import os
import sys

from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import mirror_art as art  # noqa: E402

PROJ = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
OUT_DIR = os.path.join(PROJ, 'out', 'art')
SAMPLE = os.path.join(OUT_DIR, 'sample_sword.png')
SHEET = os.path.join(OUT_DIR, 'style_sheet.png')

W, H = 1280, 840
BG = (14, 18, 24, 255)
PANEL = (22, 27, 34, 255)
PANEL_2 = (18, 23, 30, 255)
LINE = (44, 57, 68, 255)
TXT = (232, 239, 244, 255)
MUTED = (143, 163, 176, 255)
FAINT = (100, 118, 132, 255)


def _panel(d, x0, y0, x1, y1, fill=PANEL, outline=LINE):
    d.rectangle([x0, y0, x1, y1], fill=fill, outline=outline, width=1)


def _chip(d, x, y, size, color_hex, border=(0, 0, 0, 0)):
    c = art.hx(color_hex)
    d.rectangle([x, y, x + size - 1, y + size - 1], fill=c, outline=border, width=1)


def build_style_sheet(sample_path, audit):
    sheet = Image.new('RGBA', (W, H), BG)
    d = ImageDraw.Draw(sheet)

    # 背景细网格（很淡，不抢主体）
    for gx in range(0, W, 32):
        d.line([gx, 0, gx, H], fill=(18, 23, 29, 255), width=1)
    for gy in range(0, H, 32):
        d.line([0, gy, W, gy], fill=(18, 23, 29, 255), width=1)

    # 标题
    d.text((44, 28), '镜中倒影 · 美术规范 v1.0', font=art.font(34, True), fill=TXT)
    d.text((44, 76), '71 个物品图标 · 64×64 RGBA · 1px 透明边距 · 硬边像素 · 每图 ≤20 色',
           font=art.font(16), fill=MUTED)
    d.line([44, 112, W - 44, 112], fill=LINE, width=1)

    # ---------------- 左：镜银主色阶 ----------------
    d.text((44, 136), '镜银主色阶（所有镜装共用）', font=art.font(19, True), fill=TXT)
    names = ['高光', '亮面', '中间', '暗面', '最暗']
    for i, (hexv, nm) in enumerate(zip(art.MIRROR_HEX, names)):
        x = 44 + i * 104
        _chip(d, x, 172, 92, hexv, border=LINE)
        d.text((x, 272), nm, font=art.font(13, True), fill=TXT)
        d.text((x, 290), hexv, font=art.font(11), fill=MUTED)

    d.text((44, 318), '描边 #14181D · 镜面反光 1–2 条 1px 斜线 · 光源左上',
           font=art.font(12), fill=FAINT)

    # ---------------- 左：六套强调色 ----------------
    d.text((44, 350), '六套强调色 · 纹样', font=art.font(19, True), fill=TXT)
    card_w, card_h = 330, 130
    for idx, key in enumerate(art.SET_ORDER):
        st = art.SET_STYLE[key]
        col = idx % 2
        row = idx // 2
        x = 44 + col * (card_w + 16)
        y = 384 + row * (card_h + 14)
        _panel(d, x, y, x + card_w, y + card_h)
        # 左侧双色块
        _chip(d, x + 14, y + 16, 46, st['accent'][0], border=(0, 0, 0, 255))
        _chip(d, x + 14, y + 68, 46, st['accent'][1], border=(0, 0, 0, 255))
        # 套装名
        d.text((x + 76, y + 12), st['name'], font=art.font(22, True), fill=TXT)
        d.text((x + 76, y + 44), st['motif'], font=art.font(13), fill=MUTED)
        d.text((x + 76, y + 68), st['accent'][0], font=art.font(11), fill=FAINT)
        d.text((x + 76, y + 84), st['accent'][1], font=art.font(11), fill=FAINT)
        # 底部一条纹样色带
        d.rectangle([x + 14, y + card_h - 22, x + card_w - 14, y + card_h - 14],
                    fill=art.hx(st['accent'][0]), outline=None)
        d.rectangle([x + card_w - 46, y + card_h - 22, x + card_w - 14, y + card_h - 14],
                    fill=art.hx(st['accent'][1]), outline=None)

    # ---------------- 右：样例剑 ----------------
    d.text((760, 136), '样例：照心镜剑（圆镜盘 + 同心波纹）', font=art.font(19, True), fill=TXT)

    # 4×
    checker = art.checker_board(256, 256, 32)
    im = Image.open(sample_path).convert('RGBA')
    checker.alpha_composite(im.resize((256, 256), Image.NEAREST), (0, 0))
    sheet.alpha_composite(checker, (760, 172))
    d.rectangle([760, 172, 1015, 427], outline=LINE, width=1)
    d.text((760, 436), '4×（256×256，最近邻）', font=art.font(12), fill=MUTED)

    # 1×
    checker1 = art.checker_board(64, 64, 8)
    checker1.alpha_composite(im, (0, 0))
    sheet.alpha_composite(checker1, (1040, 172))
    d.rectangle([1040, 172, 1103, 235], outline=LINE, width=1)
    d.text((1040, 244), '1×（64×64）', font=art.font(12), fill=MUTED)

    # 16×16 预览（原尺寸缩小后再放大 4×）
    small = im.resize((16, 16), Image.NEAREST).resize((64, 64), Image.NEAREST)
    checker2 = art.checker_board(64, 64, 8)
    checker2.alpha_composite(small, (0, 0))
    sheet.alpha_composite(checker2, (1040, 284))
    d.rectangle([1040, 284, 1103, 347], outline=LINE, width=1)
    d.text((1040, 356), '16×16 原尺寸 → 4× 放大', font=art.font(12), fill=MUTED)

    # 自检读数
    d.text((760, 470), '自检', font=art.font(15, True), fill=TXT)
    lines = [
        '尺寸 %d×%d · %s · 用色 %d / 20' % (audit['size'][0], audit['size'][1],
                                              'RGBA', audit['colors']),
        '覆盖率 %.1f%% · bbox %r · alpha 0/255' % (audit['coverage'] * 100, audit['bbox']),
        '外沿 #14181D · 透明边距 1px · 校验 %s' % ('通过' if audit['ok'] else '失败'),
    ]
    for i, line in enumerate(lines):
        d.text((760, 496 + i * 21), line, font=art.font(12), fill=MUTED)

    # 验收要点
    _panel(d, 760, 574, W - 44, 780, fill=PANEL_2)
    d.text((778, 588), '验收要点', font=art.font(15, True), fill=TXT)
    bullets = [
        '16×16 可读：缩到 16×16 仍能认出剪影与套别',
        '六套可区分：强调色 + 纹样双重差异，不靠文字',
        '四件同套同纹：盔额 / 胸心 / 腰带 / 靴踝调用同一 motif',
        '剪影互不相似：六把武器两两 IoU < 0.55（剪影检查）',
        'alpha 二值、无半透明边缘；最外圈 1px 透明',
        '武器/防具 64×64；材料同样 64×64，同描边语言',
    ]
    for i, b in enumerate(bullets):
        d.text((778, 616 + i * 24), '· ' + b, font=art.font(12), fill=MUTED)

    # 页脚
    d.line([44, 804, W - 44, 804], fill=LINE, width=1)
    d.text((44, 812), '生成：python src/tools/art/gen_sample.py    单一事实源：src/tools/art/manifest.json',
           font=art.font(11), fill=FAINT)
    d.text((W - 44 - 260, 812), 'out/art/style_sheet.png', font=art.font(11), fill=FAINT)

    sheet.convert('RGBA').save(SHEET)
    return SHEET


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    style = art.SET_STYLE['zhao']
    canvas = art.draw_sword(style)
    audit = canvas.audit()
    if not audit['ok']:
        for e in audit['errors']:
            print('SAMPLE ERROR: ' + e, file=sys.stderr)
        return 1
    canvas.save(SAMPLE)

    # 硬确认：落盘后重新读，尺寸/模式/自检都要过
    im = Image.open(SAMPLE)
    if im.size != (64, 64):
        print('SAMPLE ERROR: 尺寸 %r，不是 64×64' % (im.size,), file=sys.stderr)
        return 1
    if im.mode != 'RGBA':
        print('SAMPLE ERROR: 模式 %s，不是 RGBA' % im.mode, file=sys.stderr)
        return 1
    file_audit = art.audit_icon_file(SAMPLE)
    if not file_audit['ok']:
        for e in file_audit['errors']:
            print('SAMPLE FILE ERROR: ' + e, file=sys.stderr)
        return 1

    sheet = build_style_sheet(SAMPLE, file_audit)
    print('sample  -> %s  %dx%d %s colors=%d coverage=%.1f%%' %
          (SAMPLE, im.size[0], im.size[1], im.mode, file_audit['colors'],
           file_audit['coverage'] * 100))
    print('sheet   -> %s  %dx%d' % (sheet, Image.open(sheet).size[0], Image.open(sheet).size[1]))
    print('audit   -> ' + ('PASS' if file_audit['ok'] else 'FAIL'))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
