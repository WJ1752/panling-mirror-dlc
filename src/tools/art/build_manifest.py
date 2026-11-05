# -*- coding: utf-8 -*-
"""
build_manifest —— 生成《梦回盘灵：镜中倒影》71 张物品图标的单一事实源。

输出：src/tools/art/manifest.json

事实来源（本脚本只读，不修改数据包/资源包）：
  * src/tools/gen_table_rest.py:20-26       六把武器的 key / 载体 / CMD
  * src/tools/gen_table_rest.py:53-72       六套防具的 key / 部件 / CMD 200+si*4+pi
  * src/datapack/data/plm/functions/mirror/table/output/weapon.mcfunction:2-7
  * src/datapack/data/plm/functions/mirror/table/output/armor.mcfunction:2-25
  * src/datapack/data/plm/functions/dev/give_mats.mcfunction:2-34
  * src/resourcepack/assets/lang_mirror/lang/zh_cn.json（显示名）
  * src/tools/pack_lint.py:58-60（现行 CMD 段位；370-371 需同步为 370-379）

模具 CMD 变更（本清单记录，数据包由工程集成者同步）：
  旧：6 种武器胚共用 370，4 种防具胚共用 371（give_mats.mcfunction:12-21）
  新：武器胚 370-375，防具胚 376-379，一物一图
"""
from __future__ import annotations

import io
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import mirror_art as art  # noqa: E402

OUT = os.path.join(HERE, 'manifest.json')
TEXTURE_ROOT = 'assets/panling/textures/item'
MODEL_ROOT = 'assets/panling/models/item'

WEAPONS = [
    # (key, builder, set, carrier, cmd, parent, display_lang)
    ('mirror_sword7', 'sword', 'zhao', 'minecraft:netherite_sword', 100, 'item/handheld',
     'pl.item.name.mirror_sword7'),
    ('mirror_axe7', 'axe', 'lie', 'minecraft:netherite_axe', 101, 'item/handheld',
     'pl.item.name.mirror_axe7'),
    ('mirror_bow7', 'bow', 'jing', 'minecraft:bow', 102, 'item/bow',
     'pl.item.name.mirror_bow7'),
    ('mirror_crossbow7', 'crossbow', 'can', 'minecraft:crossbow', 103, 'item/crossbow',
     'pl.item.name.mirror_crossbow7'),
    ('mirror_furnace_twin7', 'twin_furnace', 'twin', 'minecraft:netherite_hoe', 104,
     'item/handheld', 'pl.item.name.mirror_furnace_twin7'),
    ('mirror_furnace_rub7', 'rub_furnace', 'rub', 'minecraft:netherite_shovel', 105,
     'item/handheld', 'pl.item.name.mirror_furnace_rub7'),
]

BOW_STATES = [
    ('static', '', None),
    ('pulling_0', '_pulling_0', {'pulling': True, 'pull': 0.0}),
    ('pulling_1', '_pulling_1', {'pulling': True, 'pull': 0.65}),
    ('pulling_2', '_pulling_2', {'pulling': True, 'pull': 0.9}),
]

CROSSBOW_STATES = [
    ('static', '', None),
    ('pulling_0', '_pulling_0', {'pulling': True, 'pull': 0.0}),
    ('pulling_1', '_pulling_1', {'pulling': True, 'pull': 0.58}),
    ('pulling_2', '_pulling_2', {'pulling': True, 'pull': 1.0}),
    ('arrow', '_arrow', {'charged': True}),
    ('firework', '_firework', {'charged': True, 'firework': True}),
]

ARMOR_SETS = [
    ('zhao', '照心', 10),
    ('lie', '裂影', 11),
    ('jing', '镜花', 12),
    ('can', '残影', 13),
    ('twin', '双生', 14),
    ('rub', '拓印', 15),
]

ARMOR_PARTS = [
    ('helmet', '盔', 0, 'head', 'netherite_helmet'),
    ('chestplate', '甲', 1, 'chest', 'netherite_chestplate'),
    ('leggings', '腿', 2, 'legs', 'netherite_leggings'),
    ('boots', '靴', 3, 'feet', 'netherite_boots'),
]

# 材料：key, 分类, 画具 variant, 元素/套装, CMD, 载体
MATERIALS = [
    # 镜片 ×5（netherite_scrap, 300/305/310/315/320）
    ('mirror_shard_metal', 'shard', 'metal', 'metal', 300, 'netherite_scrap'),
    ('mirror_shard_wood', 'shard', 'wood', 'wood', 305, 'netherite_scrap'),
    ('mirror_shard_water', 'shard', 'water', 'water', 310, 'netherite_scrap'),
    ('mirror_shard_fire', 'shard', 'fire', 'fire', 315, 'netherite_scrap'),
    ('mirror_shard_earth', 'shard', 'earth', 'earth', 320, 'netherite_scrap'),
    # 镜心 ×5（amethyst_shard, 340-360）
    ('mirror_heart_metal', 'heart', 'metal', 'metal', 340, 'amethyst_shard'),
    ('mirror_heart_wood', 'heart', 'wood', 'wood', 345, 'amethyst_shard'),
    ('mirror_heart_water', 'heart', 'water', 'water', 350, 'amethyst_shard'),
    ('mirror_heart_fire', 'heart', 'fire', 'fire', 355, 'amethyst_shard'),
    ('mirror_heart_earth', 'heart', 'earth', 'earth', 360, 'amethyst_shard'),
    # 镜胚 ×10（flint 370-375 / charcoal 376-379；旧 370/371 共用）
    ('mirror_mold_sword', 'mold', 'sword', None, 370, 'flint'),
    ('mirror_mold_axe', 'mold', 'axe', None, 371, 'flint'),
    ('mirror_mold_bow', 'mold', 'bow', None, 372, 'flint'),
    ('mirror_mold_crossbow', 'mold', 'crossbow', None, 373, 'flint'),
    ('mirror_mold_furnace_twin', 'mold', 'furnace_twin', None, 374, 'flint'),
    ('mirror_mold_furnace_rub', 'mold', 'furnace_rub', None, 375, 'flint'),
    ('mirror_mold_helmet', 'mold', 'helmet', None, 376, 'charcoal'),
    ('mirror_mold_chestplate', 'mold', 'chestplate', None, 377, 'charcoal'),
    ('mirror_mold_leggings', 'mold', 'leggings', None, 378, 'charcoal'),
    ('mirror_mold_boots', 'mold', 'boots', None, 379, 'charcoal'),
    # 镜缘 ×6（quartz, 380-385）
    ('mirror_edge_zhao', 'edge', 'zhao', 'zhao', 380, 'quartz'),
    ('mirror_edge_lie', 'edge', 'lie', 'lie', 381, 'quartz'),
    ('mirror_edge_jing', 'edge', 'jing', 'jing', 382, 'quartz'),
    ('mirror_edge_can', 'edge', 'can', 'can', 383, 'quartz'),
    ('mirror_edge_twin', 'edge', 'twin', 'twin', 384, 'quartz'),
    ('mirror_edge_rub', 'edge', 'rub', 'rub', 385, 'quartz'),
    # 影尘 / 砺镜砂（gunpowder 390 / glowstone_dust 391）
    ('mirror_dust', 'dust', None, None, 390, 'gunpowder'),
    ('mirror_sand', 'sand', None, None, 391, 'glowstone_dust'),
    # 定影符 ×4（paper, 400-403）
    ('mirror_seal_1', 'seal', 1, None, 400, 'paper'),
    ('mirror_seal_2', 'seal', 2, None, 401, 'paper'),
    ('mirror_seal_3', 'seal', 3, None, 402, 'paper'),
    ('mirror_seal_rev', 'seal', 'rev', None, 403, 'paper'),
    # 倒影核（nautilus_shell, 410）
    ('mirror_core', 'core', None, None, 410, 'nautilus_shell'),
]

MATERIAL_LABELS = {
    'shard': '镜片', 'heart': '镜心', 'mold': '镜胚', 'edge': '镜缘',
    'dust': '影尘', 'sand': '砺镜砂', 'seal': '定影符', 'core': '倒影核',
}

# 旧 CMD（仅用于记录变更；新清单以本文件的 CMD 为准）
OLD_MOLD_CMD = {
    'sword': 370, 'axe': 370, 'bow': 370, 'crossbow': 370,
    'furnace_twin': 370, 'furnace_rub': 370,
    'helmet': 371, 'chestplate': 371, 'leggings': 371, 'boots': 371,
}


def lang():
    p = os.path.join(os.path.dirname(os.path.dirname(HERE)), 'resourcepack',
                     'assets', 'lang_mirror', 'lang', 'zh_cn.json')
    with io.open(p, encoding='utf-8') as f:
        return json.load(f)


def carrier_model_path(carrier):
    name = carrier.split(':', 1)[1]
    return 'assets/minecraft/models/item/%s.json' % name


def entry_base(key, kind, category, builder, set_key, part, state, carrier, cmd,
               display_name, lang_key, parent, predicate=None, note=None):
    style = art.SET_STYLE.get(set_key) if set_key else None
    return {
        'key': key,
        'kind': kind,
        'category': category,
        'builder': builder,
        'set': set_key,
        'set_name': style['name'] if style else None,
        'part': part,
        'state': state,
        'texture': '%s/%s.png' % (TEXTURE_ROOT, key),
        'model': 'panling:item/%s' % key,
        'model_path': '%s/%s.json' % (MODEL_ROOT, key),
        'carrier': 'minecraft:%s' % carrier,
        'carrier_model': carrier_model_path('minecraft:%s' % carrier),
        'cmd': cmd,
        'display_name': display_name,
        'lang_key': lang_key,
        'item_id': 'panling:%s' % key,
        'parent': parent,
        'predicate': predicate,
        'motif': style['motif'] if style else None,
        'accent': list(style['accent']) if style else None,
        'note': note,
    }


def build_entries(L):
    out = []

    # ---- 武器 14 -------------------------------------------------
    for key, builder, set_key, carrier, cmd, parent, lang_key in WEAPONS:
        base_name = L[lang_key]
        style = art.SET_STYLE[set_key]
        if builder == 'bow':
            for state, suffix, pred in BOW_STATES:
                e = entry_base(
                    key + suffix, 'weapon', 'bow', 'bow', set_key, 'weapon', state,
                    carrier.split(':', 1)[1], cmd, base_name, lang_key, parent, pred,
                    note='同一 CMD 102 的四条 override 之一；拉弓谓词不能换 CMD')
                e['item_id'] = 'panling:%s' % key
                e['item_id_shared_across_states'] = True
                out.append(e)
        elif builder == 'crossbow':
            for state, suffix, pred in CROSSBOW_STATES:
                e = entry_base(
                    key + suffix, 'weapon', 'crossbow', 'crossbow', set_key, 'weapon',
                    state, carrier.split(':', 1)[1], cmd, base_name, lang_key, parent, pred,
                    note='同一 CMD 103 的六条 override 之一；static/pulling/arrow/firework')
                e['item_id'] = 'panling:%s' % key
                e['item_id_shared_across_states'] = True
                out.append(e)
        else:
            e = entry_base(
                key, 'weapon', builder, builder, set_key, 'weapon', 'static',
                carrier.split(':', 1)[1], cmd, base_name, lang_key, parent, None,
                note='%s；%s' % (style['weapon'], style['motif']))
            e['item_id'] = 'panling:%s' % key
            out.append(e)

    # ---- 防具 24 -------------------------------------------------
    for si, (skey, scn, setid) in enumerate(ARMOR_SETS):
        for pi, (part, pcn, slot_idx, slot_name, carrier_name) in enumerate(ARMOR_PARTS):
            cmd = 200 + si * 4 + pi
            key = 'mirror_%s_%s' % (skey, part)
            lang_key = 'pl.item.name.mirror_%s_%d' % (skey, pi + 1)
            e = entry_base(
                key, 'armor', 'armor', 'armor', skey, part, 'static', carrier_name, cmd,
                L[lang_key], lang_key, 'item/generated', None,
                note='%s·%s；四件共用纹样「%s」' % (scn, pcn, art.SET_STYLE[skey]['motif']))
            e['item_id'] = 'panling:mirror_%s_%d' % (skey, si + 1)
            e['set_bonus_id'] = setid
            e['armor_slot'] = slot_name
            e['item_id_shared_across_parts'] = True
            out.append(e)

    # ---- 材料 33 -------------------------------------------------
    for key, category, variant, extra, cmd, carrier in MATERIALS:
        lang_key = 'pl.item.name.%s' % key
        e = entry_base(
            key, 'material', category, 'material', extra, 'material', 'static',
            carrier, cmd, L[lang_key], lang_key, 'item/generated', None, None)
        e['material'] = category
        e['variant'] = variant
        e['element'] = extra if category in ('shard', 'heart') else None
        e['cmd_previous'] = OLD_MOLD_CMD.get(variant) if category == 'mold' else None
        e['cmd_changed'] = bool(category == 'mold')
        if category == 'mold':
            e['note'] = '模具 CMD 拆分：旧 %d → 新 %d；数据包需同步' % (
                OLD_MOLD_CMD[variant], cmd)
        elif category == 'edge':
            e['note'] = '镜缘·%s；弧形镜框段 + 强调色嵌条' % art.SET_STYLE[variant]['name']
        elif category == 'seal':
            e['note'] = '纸符 + 底部撕裂 + 朱砂印章；反符为紫墨倒印'
        out.append(e)

    return out


def validate(entries, L):
    errors = []
    if len(entries) != 71:
        errors.append('总数应为 71，实际 %d' % len(entries))
    kinds = {}
    for e in entries:
        kinds[e['kind']] = kinds.get(e['kind'], 0) + 1
    if kinds.get('weapon') != 14:
        errors.append('武器应为 14，实际 %d' % kinds.get('weapon', 0))
    if kinds.get('armor') != 24:
        errors.append('防具应为 24，实际 %d' % kinds.get('armor', 0))
    if kinds.get('material') != 33:
        errors.append('材料应为 33，实际 %d' % kinds.get('material', 0))

    keys = [e['key'] for e in entries]
    if len(set(keys)) != len(keys):
        dup = sorted({k for k in keys if keys.count(k) > 1})
        errors.append('key 重复：%r' % dup)
    textures = [e['texture'] for e in entries]
    if len(set(textures)) != len(textures):
        errors.append('贴图路径重复')
    models = [e['model'] for e in entries]
    if len(set(models)) != len(models):
        errors.append('模型 id 重复')

    # 弓 4 / 弩 6
    bow = [e for e in entries if e['category'] == 'bow']
    xbow = [e for e in entries if e['category'] == 'crossbow']
    if len(bow) != 4 or len({e['cmd'] for e in bow}) != 1:
        errors.append('弓应为 4 态、共用 1 个 CMD')
    if len(xbow) != 6 or len({e['cmd'] for e in xbow}) != 1:
        errors.append('弩应为 6 态、共用 1 个 CMD')

    # 防具 CMD 200-223 全覆盖
    armor_cmds = sorted(e['cmd'] for e in entries if e['kind'] == 'armor')
    if armor_cmds != list(range(200, 224)):
        errors.append('防具 CMD 未覆盖 200-223：%r' % armor_cmds)

    # 模具 CMD 370-379 全覆盖
    mold_cmds = sorted(e['cmd'] for e in entries if e['category'] == 'mold')
    if mold_cmds != list(range(370, 380)):
        errors.append('模具 CMD 未覆盖 370-379：%r' % mold_cmds)

    # 材料分段
    want = {'shard': 5, 'heart': 5, 'mold': 10, 'edge': 6, 'dust': 1, 'sand': 1,
            'seal': 4, 'core': 1}
    got = {}
    for e in entries:
        if e['kind'] == 'material':
            got[e['category']] = got.get(e['category'], 0) + 1
    if got != want:
        errors.append('材料分段不符：期望 %r，实际 %r' % (want, got))

    # 显示名与语言键
    for e in entries:
        if not e['display_name']:
            errors.append('%s 缺显示名' % e['key'])
        if e['lang_key'] not in L and not e['lang_key'].startswith('§'):
            errors.append('%s 的 lang_key 不在 zh_cn.json' % e['key'])

    # CMD 唯一性（弓/弩多态可共用）
    seen = {}
    for e in entries:
        if e['category'] in ('bow', 'crossbow'):
            continue
        if e['cmd'] in seen:
            errors.append('CMD %d 被 %s 与 %s 同时占用' % (e['cmd'], seen[e['cmd']], e['key']))
        seen[e['cmd']] = e['key']

    return errors, kinds, got


def main():
    L = lang()
    entries = build_entries(L)
    errors, kinds, mat_kinds = validate(entries, L)
    if errors:
        for e in errors:
            print('ERROR ' + e, file=sys.stderr)
        return 1

    manifest = {
        'schema': 'mirror-art-manifest/1',
        'project': '梦回盘灵：镜中倒影',
        'version': '1.0.0',
        'generated_by': 'src/tools/art/build_manifest.py',
        'single_source_of_truth': True,
        'resourcepack_root': 'src/resourcepack',
        'texture_root': TEXTURE_ROOT,
        'model_root': MODEL_ROOT,
        'rules': {
            'size': [64, 64],
            'mode': 'RGBA',
            'transparent_margin_px': 1,
            'max_colors': 20,
            'alpha': 'binary (0 or 255)',
            'outline': '#14181D',
            'light': 'top-left',
            'texture_format': 'PNG',
            'note': '主体（含描边）四周留 1px 透明边；icon 内部不写 display 变换，继承父模型',
        },
        'counts': {
            'total': len(entries),
            'weapon': kinds.get('weapon', 0),
            'armor': kinds.get('armor', 0),
            'material': kinds.get('material', 0),
            'weapon_detail': {
                'sword': 1, 'axe': 1, 'bow': 4, 'crossbow': 6,
                'furnace_twin': 1, 'furnace_rub': 1,
            },
            'material_detail': mat_kinds,
        },
        'cmd_allocations': [
            {'range': [100, 105], 'use': '六把武器', 'step': 1},
            {'range': [200, 223], 'use': '六套防具（6×4）', 'step': 1},
            {'range': [300, 320], 'use': '镜片×5', 'step': 5},
            {'range': [340, 360], 'use': '镜心×5', 'step': 5},
            {'range': [370, 375], 'use': '镜胚·武器六种（本次拆分）', 'step': 1},
            {'range': [376, 379], 'use': '镜胚·防具四种（本次拆分）', 'step': 1},
            {'range': [380, 385], 'use': '镜缘×6', 'step': 1},
            {'range': [390, 391], 'use': '影尘 / 砺镜砂', 'step': 1},
            {'range': [400, 403], 'use': '定影符×4', 'step': 1},
            {'range': [410, 410], 'use': '倒影核', 'step': 1},
        ],
        'integration_notes': [
            '防具 CMD 200-223 目前未写入 armor.mcfunction（该文件 0 处 CustomModelData），'
            '集成时必须按 manifest 补齐。',
            '同套四件的 NBT id 目前都为 panling:mirror_<set>_1'
            '（gen_table_rest.py:66 用 si+1 生成），部位靠 slot 区分；'
            'manifest 原样记录并在条目上标 item_id_shared_across_parts，'
            '若后续按 id 判定部位需先改数据包。',
            '镜胚 CMD 已拆为 370-379，give_mats.mcfunction:12-21 与 '
            'pack_lint.py:58-60 需同步。',
        ],
        'mold_cmd_change': {
            'reason': '旧 give_mats.mcfunction:12-21 中 6 种武器胚共用 370、4 种防具胚共用 371，'
                      '无法一物一图；v1.0 拆成 10 个 CMD。',
            'before': {'weapon_molds': 370, 'armor_molds': 371},
            'after': {
                'weapon_molds': {'sword': 370, 'axe': 371, 'bow': 372, 'crossbow': 373,
                                 'furnace_twin': 374, 'furnace_rub': 375},
                'armor_molds': {'helmet': 376, 'chestplate': 377, 'leggings': 378,
                                'boots': 379},
            },
            'datapack_files_to_sync': [
                'src/datapack/data/plm/functions/dev/give_mats.mcfunction:12-21',
            ],
            'tooling_to_sync': [
                'src/tools/pack_lint.py:58-60 CMD_RESERVED 的 (370,371) 需改为 (370,379)',
            ],
            'changed_by_this_deliverable': False,
            'note': '本清单只记录事实，未改数据包；工程集成者按本表同步。',
        },
        'palette': {
            'outline': art.OUTLINE_HEX,
            'mirror': list(art.MIRROR_HEX),
        },
        'sets': {
            k: {
                'name': v['name'],
                'motif': v['motif'],
                'accent': list(v['accent']),
                'accent_dark': v['accent_dark'],
                'weapon': v['weapon'],
                'armor': v['armor'],
            } for k, v in art.SET_STYLE.items()
        },
        'elements': {
            k: {'cn': v['cn'], 'base': v['base'], 'light': v['light'], 'dark': v['dark']}
            for k, v in art.ELEMENT_COLORS.items()
        },
        'carriers': _carriers(entries),
        'sources': [
            '镜中倒影_DLC设计文档_v0.1.md §4（六套机制与意象）',
            '镜中倒影_罪之笔拆解与贴图替换方案_v0.1.md §5/§7（CMD 段位、整文件覆盖、美术规格）',
            'src/tools/gen_table_rest.py:20-26（武器 key/载体/CMD）',
            'src/tools/gen_table_rest.py:53-72（防具 CMD 200+si*4+pi）',
            'src/datapack/data/plm/functions/mirror/table/output/weapon.mcfunction:2-7',
            'src/datapack/data/plm/functions/mirror/table/output/armor.mcfunction:2-5（四件同套样本；全表由 gen_table_rest.py:60-72 生成）',
            'src/datapack/data/plm/functions/dev/give_mats.mcfunction:2-34',
            'src/resourcepack/assets/lang_mirror/lang/zh_cn.json（63 条显示名）',
            'src/tools/pack_lint.py:58-60（现行 CMD_RESERVED）',
        ],
        'entries': entries,
    }

    with io.open(OUT, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)
        f.write('\n')

    print('manifest -> %s' % OUT)
    print('  total=%d weapon=%d armor=%d material=%d' %
          (len(entries), kinds.get('weapon', 0), kinds.get('armor', 0),
           kinds.get('material', 0)))
    print('  material_detail=%r' % mat_kinds)
    print('  bow=4 crossbow=6 armor_cmd=200-223 mold_cmd=370-379')
    return 0


def _carriers(entries):
    by = {}
    for e in entries:
        c = e['carrier']
        item = by.setdefault(c, {
            'item': c,
            'model_path': e['carrier_model'],
            'cmds': [],
            'keys': [],
        })
        if e['cmd'] not in item['cmds']:
            item['cmds'].append(e['cmd'])
        item['keys'].append(e['key'])
    return [by[k] for k in sorted(by)]


if __name__ == '__main__':
    raise SystemExit(main())
