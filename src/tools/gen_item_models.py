# -*- coding: utf-8 -*-
"""
gen_item_models —— 《梦回盘灵：镜中倒影》物品模型生成器

读取 src/tools/art/manifest.json（唯一数据源），生成：

  1. 71 个图标模型  assets/panling/models/item/<key>.json
       武器（剑/斧/双生炉/拓印炉） parent = item/handheld
       弓 / 弩                     parent = item/bow / item/crossbow
       防具 / 材料                 parent = item/generated
       textures.layer0 = panling:item/<key>；不写 display，继承父模型。

  2. 17 个新建载体模型 assets/minecraft/models/item/<item>.json
       netherite_sword/axe/hoe/shovel、netherite_helmet/chestplate/leggings/boots、
       netherite_scrap、amethyst_shard、flint、charcoal、quartz、
       gunpowder、glowstone_dust、paper、nautilus_shell
       保留原版 parent / textures.layer0，追加 manifest 里的 CMD override。

  3. 2 个合并补丁 assets/minecraft/models/item/{bow,crossbow}.json
       只写 "__merge_with_base__": true 与 overrides；
       由 build.py 在打包时读取本体 RP 同名 JSON 合并（本体条目在前、我们的在后）。
       谓词与本体逐字段一致：弓 pulling / pull 0.65 / 0.9；
       弩 pulling / pull 0.58 / 1.0、charged、charged+firework。

用法：
  python -I src/tools/gen_item_models.py
  python -I src/tools/gen_item_models.py --check   # 只校验不写盘
"""
from __future__ import annotations

import argparse
import io
import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

HERE = os.path.dirname(os.path.abspath(__file__))          # src/tools
SRC = os.path.dirname(HERE)                                # src
PROJ = os.path.dirname(SRC)                                # 项目根
RP = os.path.join(SRC, 'resourcepack')
MANIFEST = os.path.join(HERE, 'art', 'manifest.json')

MERGE_MARKER = '__merge_with_base__'

# 原版物品模型骨架：parent + layer0（1.20.1 客户端 jar 的 item/<name>.json）
VANILLA_CARRIERS = {
    'minecraft:netherite_sword': ('item/handheld', 'item/netherite_sword'),
    'minecraft:netherite_axe': ('item/handheld', 'item/netherite_axe'),
    'minecraft:netherite_hoe': ('item/handheld', 'item/netherite_hoe'),
    'minecraft:netherite_shovel': ('item/handheld', 'item/netherite_shovel'),
    'minecraft:netherite_helmet': ('item/generated', 'item/netherite_helmet'),
    'minecraft:netherite_chestplate': ('item/generated', 'item/netherite_chestplate'),
    'minecraft:netherite_leggings': ('item/generated', 'item/netherite_leggings'),
    'minecraft:netherite_boots': ('item/generated', 'item/netherite_boots'),
    'minecraft:netherite_scrap': ('item/generated', 'item/netherite_scrap'),
    'minecraft:amethyst_shard': ('item/generated', 'item/amethyst_shard'),
    'minecraft:flint': ('item/generated', 'item/flint'),
    'minecraft:charcoal': ('item/generated', 'item/charcoal'),
    'minecraft:quartz': ('item/generated', 'item/quartz'),
    'minecraft:gunpowder': ('item/generated', 'item/gunpowder'),
    'minecraft:glowstone_dust': ('item/generated', 'item/glowstone_dust'),
    'minecraft:paper': ('item/generated', 'item/paper'),
    'minecraft:nautilus_shell': ('item/generated', 'item/nautilus_shell'),
}

# 弓 / 弩的状态谓词，与本体 bow.json / crossbow.json 完全一致
# （pulling_0 本体不写 pull，不能补 0.0；否则与本体不再是同一谓词）
STATE_PREDICATES = {
    'bow': {
        'static': {},
        'pulling_0': {'pulling': 1},
        'pulling_1': {'pulling': 1, 'pull': 0.65},
        'pulling_2': {'pulling': 1, 'pull': 0.9},
    },
    'crossbow': {
        'static': {},
        'pulling_0': {'pulling': 1},
        'pulling_1': {'pulling': 1, 'pull': 0.58},
        'pulling_2': {'pulling': 1, 'pull': 1.0},
        'arrow': {'charged': 1},
        'firework': {'charged': 1, 'firework': 1},
    },
}
STATE_ORDER = {
    'bow': ['static', 'pulling_0', 'pulling_1', 'pulling_2'],
    'crossbow': ['static', 'pulling_0', 'pulling_1', 'pulling_2', 'arrow', 'firework'],
}


def load_manifest():
    with io.open(MANIFEST, encoding='utf-8') as f:
        return json.load(f)


def icon_parent(entry):
    b = entry.get('builder')
    if b == 'bow':
        return 'item/bow'
    if b == 'crossbow':
        return 'item/crossbow'
    if b in ('sword', 'axe', 'twin_furnace', 'rub_furnace'):
        return 'item/handheld'
    return 'item/generated'


def icon_model(entry):
    return {
        'parent': icon_parent(entry),
        'textures': {'layer0': 'panling:item/%s' % entry['key']},
    }


def override_for(entry):
    """生成单条 override；弓弩的谓词按 STATE_PREDICATES 归一化。"""
    builder = entry.get('builder')
    if builder in STATE_PREDICATES:
        state = entry.get('state', 'static')
        base = STATE_PREDICATES[builder].get(state)
        if base is None:
            raise SystemExit('未知状态 %s/%s（%s）' % (builder, state, entry['key']))
        pred = dict(base)
    else:
        pred = dict(entry.get('predicate') or {})
    pred['custom_model_data'] = entry['cmd']
    return {'predicate': pred, 'model': entry.get('model', 'panling:item/%s' % entry['key'])}


def carrier_models(m):
    """按载体分组，保持 manifest 顺序（= 状态/CMD 顺序）。"""
    groups = {}
    for e in m['entries']:
        groups.setdefault(e['carrier'], []).append(e)
    return groups


def build_outputs(m):
    """返回 {相对路径: (对象, 是否合并补丁)}。"""
    out = {}
    entries = m['entries']

    # ---- 1) 71 个图标模型 ----
    for e in entries:
        rel = e['model_path']
        if not rel.endswith('.json'):
            raise SystemExit('manifest 模型路径异常：%s' % rel)
        out[rel] = (icon_model(e), False)

    # ---- 2)/3) 19 个载体 ----
    groups = carrier_models(m)
    declared = {c['item']: c for c in m['carriers']}
    if set(groups) != set(declared):
        raise SystemExit('manifest.carriers 与 entries 的载体集合不一致：缺 %s，多 %s'
                         % (sorted(set(declared) - set(groups)),
                            sorted(set(groups) - set(declared))))
    for carrier, items in groups.items():
        rels = {x['carrier_model'] for x in items}
        if len(rels) != 1:
            raise SystemExit('%s 的 carrier_model 不一致：%s' % (carrier, sorted(rels)))
        if declared[carrier].get('model_path') != items[0]['carrier_model']:
            raise SystemExit('%s 的 carrier_model 与 manifest.carriers 不一致：%s vs %s'
                             % (carrier, items[0]['carrier_model'],
                                declared[carrier].get('model_path')))

    for carrier, items in groups.items():
        rel = items[0]['carrier_model']
        builder = items[0].get('builder')
        if builder in STATE_PREDICATES:
            # 合并补丁：只放标记 + 我们的 override
            order = STATE_ORDER[builder]
            by_state = {x.get('state', 'static'): x for x in items}
            if set(by_state) != set(order):
                raise SystemExit('%s 的弓弩状态不齐：%s' % (carrier, sorted(by_state)))
            overrides = [override_for(by_state[s]) for s in order]
            out[rel] = ({MERGE_MARKER: True, 'overrides': overrides}, True)
            continue

        if carrier not in VANILLA_CARRIERS:
            raise SystemExit('缺少 %s 的原版 parent/layer0 定义' % carrier)
        parent, layer0 = VANILLA_CARRIERS[carrier]
        # 同一载体按 CMD 升序；同 CMD 的多条（仅弓弩）走上面的补丁分支
        ordered = sorted(items, key=lambda x: (x['cmd'], x['key']))
        out[rel] = ({
            'parent': parent,
            'textures': {'layer0': layer0},
            'overrides': [override_for(x) for x in ordered],
        }, False)

    return out


def write_json(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    text = json.dumps(obj, ensure_ascii=False, indent=2) + '\n'
    io.open(path, 'w', encoding='utf-8', newline='\n').write(text)


def main():
    ap = argparse.ArgumentParser(description='生成镜中倒影的物品模型')
    ap.add_argument('--check', action='store_true', help='只校验 manifest 与生成结果，不写盘')
    args = ap.parse_args()

    m = load_manifest()
    outputs = build_outputs(m)

    icons = [r for r, (o, merge) in outputs.items()
             if r.startswith('assets/panling/models/item/')]
    carriers = [r for r in outputs if r not in icons]
    patches = [r for r, (o, merge) in outputs.items() if merge]

    if len(icons) != 71:
        raise SystemExit('图标模型应为 71 个，实际 %d 个' % len(icons))
    if len(carriers) != 19:
        raise SystemExit('载体模型应为 19 个，实际 %d 个' % len(carriers))
    if len(patches) != 2:
        raise SystemExit('合并补丁应为 2 个，实际 %d 个' % len(patches))

    if args.check:
        print('检查通过：71 图标 + 19 载体（其中 2 个合并补丁）')
        return 0

    for rel, (obj, merge) in sorted(outputs.items()):
        write_json(os.path.join(RP, rel), obj)

    print('已生成 71 个图标模型 + 19 个载体模型（2 个合并补丁）')
    print('  图标：assets/panling/models/item/*.json')
    print('  载体：assets/minecraft/models/item/{bow,crossbow}.json 为补丁，其余 17 个为完整模型')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
