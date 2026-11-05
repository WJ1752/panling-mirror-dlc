# -*- coding: utf-8 -*-
"""gen_trim_integration —— 把六套盔甲纹饰接入数据包 / 资源包

产物（全部由 src/tools/art/trim_manifest.json 驱动）：
  src/datapack/data/plm/trim_pattern/<set>.json      ×6
  src/datapack/data/plm/trim_material/<set>.json     ×6
  src/resourcepack/assets/minecraft/atlases/armor_trims.json
  src/resourcepack/assets/minecraft/textures/trims/color_palettes/trim_palette.png
  src/resourcepack/assets/lang_mirror/lang/zh_cn.json（补 12 条 trim 键）

1.20.1 口径（据客户端 jar 字节码核实）：
  * TrimPattern.asset_id 是短 id（原版 `minecraft:sentry`），渲染时拼
        trims/models/armor/<asset_id.path>_<material.asset_name>
        trims/models/armor/<asset_id.path>_leggings_<material.asset_name>
    再取图集 sprite；所以这里写 `plm:<set>`，图集纹理写
    `plm:trims/models/armor/<set>`（namespace 随 asset_id 走）。
  * armor_trims.json 用两个 source：
      - source 0：原版 32 pattern + 14 permutation 原样，palette_key 仍是原版
        `trims/color_palettes/trim_palette`；
      - source 1：我们的 12 条 pattern + 6 个 permutation，palette_key 用
        `plm:trims/color_palettes/key`（升序 0→224）。本仓 palette 按“深→浅”
        落盘，只有配升序 key 才能让 224 映射到最浅色，避免明暗反转。

用法：
  python -I src/tools/gen_trim_integration.py
  python -I src/tools/gen_trim_integration.py --check
  python -I src/tools/gen_trim_integration.py --jar <客户端 jar 路径>
"""
from __future__ import annotations

import argparse
import copy
import io
import json
import os
import sys
import zipfile

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

HERE = os.path.dirname(os.path.abspath(__file__))          # src/tools
SRC = os.path.dirname(HERE)                                # src
PROJ = os.path.dirname(SRC)                                # 项目根
MANIFEST = os.path.join(HERE, 'art', 'trim_manifest.json')

DP = os.path.join(SRC, 'datapack', 'data', 'plm')
RP = os.path.join(SRC, 'resourcepack')
ATLAS = os.path.join(RP, 'assets', 'minecraft', 'atlases', 'armor_trims.json')
TRIM_PALETTE = os.path.join(RP, 'assets', 'minecraft', 'textures', 'trims',
                            'color_palettes', 'trim_palette.png')
LANG = os.path.join(RP, 'assets', 'lang_mirror', 'lang', 'zh_cn.json')

DEFAULT_JAR = os.path.join(os.environ.get('APPDATA', os.path.expanduser('~')),
                           '.minecraft', 'versions', '1.20.1', '1.20.1.jar')

PATTERN_ASSET = 'plm:trims/models/armor/%s'
PALETTE_PATH = 'plm:trims/color_palettes/%s'
PLM_PALETTE_KEY = 'plm:trims/color_palettes/key'
VANILLA_PALETTE_KEY = 'trims/color_palettes/trim_palette'
TEMPLATE_ITEM = 'minecraft:air'
INGREDIENT = 'minecraft:quartz'


def read_json(path):
    with io.open(path, encoding='utf-8') as fh:
        return json.load(fh)


def dump(obj):
    return json.dumps(obj, ensure_ascii=False, indent=2) + '\n'


def load_manifest():
    m = read_json(MANIFEST)
    order = list(m['sets'].keys())
    assert len(order) == 6, order
    return m, order


def trim_pattern(key):
    """TrimPattern.asset_id 是短 id；渲染端自己加 trims/models/armor/ 前缀。"""
    return {
        'asset_id': 'plm:%s' % key,
        'description': {'translate': 'trim_pattern.plm.%s' % key},
        'template_item': TEMPLATE_ITEM,
    }


def trim_material(key, color, index):
    return {
        'asset_name': key,
        'description': {'color': color, 'translate': 'trim_material.plm.%s' % key},
        'ingredient': INGREDIENT,
        'item_model_index': index,
    }


def plm_atlas_textures(order):
    textures = []
    for key in order:
        textures.append(PATTERN_ASSET % key)
        textures.append(PATTERN_ASSET % (key + '_leggings'))
    return textures


def plm_atlas_permutations(order):
    return {key: PALETTE_PATH % key for key in order}


def merged_atlas_source(vanilla_source, order):
    """原版 source 原样，追加我们的纹理与 permutation；palette_key 保持原版。"""
    src = copy.deepcopy(vanilla_source)
    src['textures'] = list(src['textures']) + plm_atlas_textures(order)
    src['permutations'] = dict(src['permutations'])
    src['permutations'].update(plm_atlas_permutations(order))
    return src


def read_jar(jar_path):
    if not os.path.exists(jar_path):
        raise SystemExit('找不到客户端 jar：%s（用 --jar 指定）' % jar_path)
    with zipfile.ZipFile(jar_path) as z:
        atlas_raw = z.read('assets/minecraft/atlases/armor_trims.json')
        palette_raw = z.read('assets/minecraft/textures/trims/color_palettes/trim_palette.png')
    return json.loads(atlas_raw.decode('utf-8')), palette_raw


def plm_atlas_source(order):
    """我们的独立 source：升序 key + 12 pattern + 6 palette。"""
    return {
        'type': 'paletted_permutations',
        'textures': plm_atlas_textures(order),
        'palette_key': PLM_PALETTE_KEY,
        'separator': '_',
        'permutations': plm_atlas_permutations(order),
    }


def build_atlas(vanilla, order):
    if len(vanilla.get('sources', [])) != 1:
        raise SystemExit('原版 armor_trims.json 的 sources 不是 1 个：%d'
                         % len(vanilla.get('sources', [])))
    src = vanilla['sources'][0]
    if len(src.get('textures', [])) != 32:
        raise SystemExit('原版 pattern 数不是 32：%d' % len(src.get('textures', [])))
    if len(src.get('permutations', {})) != 14:
        raise SystemExit('原版 permutation 数不是 14：%d' % len(src.get('permutations', {})))
    return {'sources': [copy.deepcopy(src), plm_atlas_source(order)]}


def expected_lang(m, order):
    lang = {}
    for key in order:
        s = m['sets'][key]
        lang[s['lang']['pattern_key']] = s['lang']['pattern_zh']
        lang[s['lang']['material_key']] = s['lang']['material_zh']
    return lang


def merge_lang_text(text, extra):
    """在保持原文件格式的前提下，把缺失的键插到最后一个 } 之前。"""
    obj = json.loads(text)
    missing = [(k, v) for k, v in extra.items() if k not in obj]
    if not missing:
        return text, 0
    body = text.rstrip()
    if not body.endswith('}'):
        raise SystemExit('语言文件结尾不是 }，拒绝改写：%s' % LANG)
    head = body[:-1].rstrip()
    pairs = ['%s: %s' % (json.dumps(k, ensure_ascii=False), json.dumps(v, ensure_ascii=False))
             for k, v in missing]
    sep = '' if head.endswith('{') else ','
    new = head + sep + '\n  ' + ',\n  '.join(pairs) + '\n}\n'
    json.loads(new)   # 必须仍是合法 JSON
    return new, len(missing)


def targets(jar_path):
    m, order = load_manifest()
    vanilla, palette_raw = read_jar(jar_path)
    text = []
    for i, key in enumerate(order):
        text.append((os.path.join(DP, 'trim_pattern', '%s.json' % key),
                     dump(trim_pattern(key))))
        color = m['sets'][key]['accent'][0]
        text.append((os.path.join(DP, 'trim_material', '%s.json' % key),
                     dump(trim_material(key, color, round(0.1 * (i + 1), 1)))))
    text.append((ATLAS, dump(build_atlas(vanilla, order))))
    binary = [(TRIM_PALETTE, palette_raw)]
    return m, order, text, binary


def main(argv=None):
    ap = argparse.ArgumentParser(description='六套盔甲纹饰接线条目生成器')
    ap.add_argument('--check', action='store_true', help='只读复检，不写文件')
    ap.add_argument('--jar', default=os.environ.get('PLM_CLIENT_JAR', DEFAULT_JAR),
                    help='1.20.1 客户端 jar（读原版 armor_trims.json 与 trim_palette）')
    args = ap.parse_args(argv)

    m, order, text_targets, bin_targets = targets(args.jar)
    lang_extra = expected_lang(m, order)

    bad = []
    if args.check:
        for path, body in text_targets:
            if not os.path.exists(path):
                bad.append('缺文件 %s' % os.path.relpath(path, PROJ))
            elif io.open(path, encoding='utf-8').read() != body:
                bad.append('内容与来源不一致 %s' % os.path.relpath(path, PROJ))
        for path, raw in bin_targets:
            if not os.path.exists(path):
                bad.append('缺文件 %s' % os.path.relpath(path, PROJ))
            elif open(path, 'rb').read() != raw:
                bad.append('内容与来源不一致 %s' % os.path.relpath(path, PROJ))
        if os.path.exists(LANG):
            cur = read_json(LANG)
            for k in lang_extra:
                if k not in cur:
                    bad.append('语言键缺失 %s' % k)
        else:
            bad.append('缺语言文件 %s' % os.path.relpath(LANG, PROJ))
        for b in bad:
            print('  [FAIL] %s' % b)
        print('check    %s' % ('PASS' if not bad else 'FAIL %d 处' % len(bad)))
        return 0 if not bad else 1

    for path, body in text_targets:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with io.open(path, 'w', encoding='utf-8', newline='\n') as fh:
            fh.write(body)
    for path, raw in bin_targets:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'wb') as fh:
            fh.write(raw)
    print('pattern  %d 个 trim_pattern → %s'
          % (6, os.path.relpath(os.path.join(DP, 'trim_pattern'), PROJ).replace('\\', '/')))
    print('material %d 个 trim_material → %s'
          % (6, os.path.relpath(os.path.join(DP, 'trim_material'), PROJ).replace('\\', '/')))
    print('atlas    %s（原版 source 原样 + plm 独立 source：12 pattern / 6 palette）'
          % os.path.relpath(ATLAS, PROJ).replace('\\', '/'))
    print('palette  %s（原版 trim_palette 原样落地）'
          % os.path.relpath(TRIM_PALETTE, PROJ).replace('\\', '/'))

    text = io.open(LANG, encoding='utf-8').read()
    new_text, added = merge_lang_text(text, lang_extra)
    if added:
        with io.open(LANG, 'w', encoding='utf-8', newline='\n') as fh:
            fh.write(new_text)
    print('lang     %s 补 %d 条 trim 键' % (os.path.relpath(LANG, PROJ).replace('\\', '/'), added))
    return 0


if __name__ == '__main__':
    sys.exit(main())
