# -*- coding: utf-8 -*-
"""从 src/tools/art/manifest.json 生成展馆与领取函数。

产物：
  src/datapack/data/plm/functions/dev/build_gallery.mcfunction
  src/datapack/data/plm/functions/dev/give_all.mcfunction

展馆：y=100 的高台，9 列 x 7 行物品框，6 个盔甲架，3 个箱子。
"""
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # src/
DP = os.path.join(ROOT, 'datapack', 'data', 'plm', 'functions', 'dev')
MANIFEST = os.path.join(ROOT, 'tools', 'art', 'manifest.json')

with open(MANIFEST, encoding='utf-8-sig') as f:
    m = json.load(f)

entries = [e for e in m['entries'] if e.get('state') == 'static']
entries.sort(key=lambda e: ({'weapon': 0, 'armor': 1, 'material': 2}.get(e['kind'], 9), e['key']))

assert len(entries) == 63, len(entries)


def inner_tag(e):
    # 防具带盔甲纹饰：pattern/material 与套装同名（规范 §6.4）
    trim = ''
    if e.get('kind') == 'armor':
        trim = ',Trim:{pattern:"plm:%s",material:"plm:%s"}' % (e['set'], e['set'])
    return ('id:"%s",CustomModelData:%d%s,display:{Name:\'{"translate":"%s"}\'}' %
            (e['item_id'], e['cmd'], trim, e['lang_key']))


def frame_item(e):
    return '{id:"%s",Count:1b,tag:{%s}}' % (e['carrier'], inner_tag(e))


def chest_item(e, slot):
    return '{Slot:%db,id:"%s",Count:1b,tag:{%s}}' % (slot, e['carrier'], inner_tag(e))


def give_line(e):
    return 'give @p %s{%s} 1' % (e['carrier'], inner_tag(e))


def plain(name):
    return re.sub('§.', '', name)


def text_json(s):
    return json.dumps({'text': s}, ensure_ascii=False)


def sign(x, y, z, lines, facing='south'):
    msgs = ','.join("'%s'" % text_json(s) for s in (lines + [''] * 4)[:4])
    if facing:
        block = 'oak_wall_sign[facing=%s]' % facing
    else:
        block = 'oak_sign'
    return ('setblock %d %d %d %s{front_text:{messages:[%s],color:"black"}} '
            'replace' % (x, y, z, block, msgs))


# 展馆坐标：9 列（x -18..6，步长 3）× 7 行（y 120..102，步长 -3）
cols = [-18 + 3 * i for i in range(9)]
rows = [120 - 3 * i for i in range(7)]
assert len(cols) * len(rows) == 63

lines = []
lines.append('# 镜中倒影 · 全量材质展馆（由 src/tools/gen_gallery.py 生成）')
lines.append('# 用法：/function plm:dev/build_gallery')
lines.append('forceload add -32 -32 32 32')
lines.append('gamerule doDaylightCycle false')
lines.append('gamerule doMobSpawning false')
lines.append('time set 6000')
lines.append('weather clear')
lines.append('')
lines.append('# 清理旧展品')
lines.append('kill @e[type=item_frame,tag=plm_gallery]')
lines.append('kill @e[type=armor_stand,tag=plm_gallery]')
lines.append('')
lines.append('# 地面 / 墙 / 顶')
lines.append('fill -21 99 -21 9 99 1 smooth_quartz')
lines.append('fill -21 100 -21 9 122 -21 gray_concrete')
lines.append('fill -21 100 -21 -21 122 1 gray_concrete')
lines.append('fill 9 100 -21 9 122 1 gray_concrete')
lines.append('fill -21 123 -21 9 123 1 sea_lantern')
lines.append('')
lines.append('# 入口标识')
lines.append(sign(-6, 100, 0, ['镜中倒影 · 材质展厅', '物品框：图标 / 模型', '盔甲架：穿在身上的模型'], facing=None))
lines.append(sign(-6, 103, -20, ['全量 71 张贴图 / 71 个模型', '弓与弩的拉弓态：拿在手上拉弓查看', '按钮：领取全套 63 件']))
lines.append('')
lines.append('# 9×7 物品框 + 名称牌')
for idx, e in enumerate(entries):
    x = cols[idx % 9]
    y = rows[idx // 9]
    lines.append('summon item_frame %d %d -20 {Facing:3b,Tags:["plm_gallery"],Item:%s}' % (x, y, frame_item(e)))
    lines.append(sign(x, y - 1, -20, [plain(e['display_name'])]))
lines.append('')
lines.append('# 六套盔甲架（同套 4 件 + 对应武器）')
sets = ['zhao', 'lie', 'jing', 'can', 'twin', 'rub']
set_x = [-15, -9, -3, 3, 9, 15]
for si, s in enumerate(sets):
    armor = [e for e in entries if e['kind'] == 'armor' and e['set'] == s]
    armor.sort(key=lambda e: {'helmet': 0, 'chestplate': 1, 'leggings': 2, 'boots': 3}[e['part']])
    weapon = [e for e in entries if e['kind'] == 'weapon' and e['set'] == s][0]
    # 顺序：feet, legs, chest, head
    order = {'boots': 0, 'leggings': 1, 'chestplate': 2, 'helmet': 3}
    armor_sorted = sorted(armor, key=lambda e: order[e['part']])
    armor_nbt = ','.join(frame_item(e) for e in armor_sorted)
    lines.append('summon armor_stand %d 100 -6 {Tags:["plm_gallery"],ShowArms:1b,NoGravity:0b,'
                 'Rotation:[180f,0f],ArmorItems:[%s],HandItems:[%s,{}]}'
                 % (set_x[si], armor_nbt, frame_item(weapon)))
    lines.append(sign(set_x[si], 100, -4, [plain(weapon['display_name'])], facing=None))
lines.append('')
lines.append('# 三个领取箱（63 件）')
for ci in range(3):
    chunk = entries[ci * 21:(ci + 1) * 21]
    items = ','.join(chest_item(e, i) for i, e in enumerate(chunk))
    lines.append('setblock %d 100 -2 chest{Items:[%s]} replace' % (-9 + ci * 6, items))
lines.append(sign(-6, 100, -1, ['领取箱 ×3', '或点上方按钮一键领取'], facing=None))
lines.append('')
lines.append('# 一键领取按钮')
lines.append('setblock -6 100 -3 command_block{Command:"function plm:dev/give_all",auto:0b} replace')
lines.append('setblock -6 101 -3 stone_button[face=floor,facing=north] replace')
lines.append('')
lines.append('# 传送到入口并设置出生点')
lines.append('setworldspawn -6 100 -6')
lines.append('tp @a -6 100 -6')
lines.append('title @a title {"text":"镜中倒影 · 材质展厅","color":"aqua"}')
lines.append('title @a subtitle {"text":"71 张贴图 / 71 个模型 / 63 件可领取物品","color":"gray"}')
lines.append('tellraw @a {"text":"[镜中倒影] 展馆就绪。按钮在入口北侧，领取全套 63 件。","color":"aqua"}')

os.makedirs(DP, exist_ok=True)
with open(os.path.join(DP, 'build_gallery.mcfunction'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('\n'.join(lines) + '\n')

with open(os.path.join(DP, 'give_all.mcfunction'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('# 领取展馆全套 63 件（由 src/tools/gen_gallery.py 生成）\n')
    f.write('\n'.join(give_line(e) for e in entries) + '\n')

print('生成完成：build_gallery.mcfunction（%d 个物品框 + 6 个盔甲架 + 3 个箱子）、give_all.mcfunction（63 件）' % len(entries))
