# -*- coding: utf-8 -*-
"""生成磨镜台：输出函数 + 其余四动作（磨镜/定影/映度/分解）"""
import io, os

DP = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'datapack')
F = os.path.join(DP, 'data/plm/functions/mirror/table')


def wf(rel, lines):
    p = os.path.join(F, rel)
    d = os.path.dirname(p)
    if d:
        os.makedirs(d, exist_ok=True)
    io.open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')


# ================= 输出：武器 =================
# #t kind: 1剑 2斧 3弓 4弩 5双生炉 6拓印炉
# #t elem: 0金 1木 2水 3火 4土
KINDS = [
    (1, 'sword', '照心', '战·剑', 100, 'netherite_sword', 0, 1),
    (2, 'axe', '裂影', '战·斧', 101, 'netherite_axe', 0, 0),
    (3, 'bow', '镜花', '弓·弓', 102, 'bow', 1, 0),
    (4, 'crossbow', '残影', '弓·弩', 103, 'crossbow', 1, 1),
    (5, 'furnace_twin', '双生', '丹·炉', 104, 'netherite_hoe', 2, -1),
    (6, 'furnace_rub', '拓印', '丹·炉', 105, 'netherite_shovel', 2, -1),
]
BASE_ATK = {1: '24.0,atk_sp:2.0', 2: '26.6,atk_sp:1.6', 3: '22.0', 4: '22.0',
            5: '18.0', 6: '18.0'}
lines = ['# 输出：武器（由 assemble_weapon 调用，#t kind / #t elem 已设）']
for kind, key, cn, cls, cmd, carrier, job, branch in KINDS:
    br = '' if branch < 0 else ',branch:%d' % branch
    lines.append(
        'execute if score #t kind matches %d run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:%s",'
        'tag:{id:"panling:mirror_%s7",type:1,CustomModelData:%d,limit:%d%s,rare:7,limit_lvl:50,canenchant:3,'
        'mirror:1,mirror_ver:1,mirror_degree:0,mirror_line1:0,mirror_line2:0,mirror_line3:0,mirror_lock:0,'
        'mirror_elem:0,mirror_base:{base:{atk_pt:%s}},'
        'display:{Name:\'{"translate":"pl.item.name.mirror_%s7"}\',Lore:[\'{"translate":"pl.lore.rare7"}\','
        '\'[{"translate":"pl.lore.limit%d"},{"text":"  "},{"translate":"pl.lore.limit_lvl_50"}]\','
        '\'{"translate":"pl.lore.mirror_degree0"}\',\'{"translate":"pl.lore.mirror_no_line"}\']},'
        'HideFlags:63,Unbreakable:1b,act:0,modify:0}}]}'
        % (kind, carrier, key, cmd, job, br, BASE_ATK[kind], key, job))
# 写入元素值（用宏不便，改为 5 条覆盖）
lines.append('')
lines.append('# 补元素值（0金 1木 2水 3火 4土）')
for e in range(5):
    for kind, key, *_ in KINDS:
        lines.append('execute if score #t kind matches %d if score #t elem matches %d run data modify block ~ ~ ~ Items[{Slot:5b}].tag.mirror_elem set value %d' % (kind, e, e))
wf('output/weapon.mcfunction', lines)

# ================= 输出：防具 =================
# #t edge: 0照心 1裂影 2镜花 3残影 4双生 5拓印；#t part: 0盔 1甲 2腿 3靴
SETS = [('zhao', '照心', 10), ('lie', '裂影', 11), ('jing', '镜花', 12),
        ('can', '残影', 13), ('twin', '双生', 14), ('rub', '拓印', 15)]
# (部位, 部位序号, 护甲, 韧性, 生命)；CMD 由 200 + 套装序号*4 + 部位序号 单点算出，
# 不再保留各部位的旧 CMD 常量（旧 200..203 只对第一套成立，会误导后续维护）。
PARTS = [('helmet', 0, 5, 2, 6),
         ('chestplate', 1, 8, 2, 8),
         ('leggings', 2, 6, 2, 8),
         ('boots', 3, 5, 2, 6)]
lines = ['# 输出：防具（由 assemble_armor 调用，#t edge / #t part / #t elem 已设）']
for si, (skey, scn, setid) in enumerate(SETS):
    for part, pi, arm, tough, hp in PARTS:
        cmd = 200 + si * 4 + pi
        lines.append(
            'execute if score #t edge matches %d if score #t part matches %d run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:netherite_%s",'
            'tag:{id:"panling:mirror_%s_%d",type:2,CustomModelData:%d,is_armor:1,slot:%d,limit:3,rare:7,limit_lvl:50,canenchant:3,'
            'set_bonus_id:%d,mirror:1,mirror_ver:1,mirror_degree:0,mirror_line1:0,mirror_line2:0,mirror_line3:0,mirror_lock:0,'
            'mirror_base:{base:{armor:%d,toughness:%d,health:%d}},'
            'Trim:{pattern:"plm:%s",material:"plm:%s"},'
            'display:{Name:\'{"translate":"pl.item.name.mirror_%s_%d"}\',Lore:[\'{"translate":"pl.lore.rare7"}\','
            '\'{"translate":"pl.lore.limit3"}\',\'{"translate":"pl.lore.mirror_degree0"}\','
            '\'{"translate":"pl.lore.mirror_no_line"}\']},HideFlags:63,Unbreakable:1b,act:0,modify:0}}]}'
            # id 保持同套共用（manifest: item_id_shared_across_parts）；显示名按部位取 _1.._4
            # Trim：六套 pattern/material 同名，纹饰由套装序号唯一决定（规范 §6.4）
            % (si, pi, part, skey, si + 1, cmd, pi, setid, arm, tough, hp, skey, skey, skey, pi + 1))
lines.append('')
lines.append('# 补元素值（Trim 已在上面的 merge 行按套装写入）')
for e in range(5):
    for si, (skey, scn, setid) in enumerate(SETS):
        for part, pi, *_ in PARTS:
            lines.append('execute if score #t edge matches %d if score #t part matches %d if score #t elem matches %d run data modify block ~ ~ ~ Items[{Slot:5b}].tag.mirror_elem set value %d' % (si, pi, e, e))
wf('output/armor.mcfunction', lines)

# ================= 磨镜（洗练） =================
# 槽3=镜装, 槽0=砺镜砂, 槽8=影尘×10
# 重骰所有未锁定镜律（1..3），结果写入 mirror_line1..3（未锁的）
wf('act/polish.mcfunction', [
    '# ---- 磨镜：槽3 必须是镜装 ----',
    'execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run return 0',
    '# 槽0 必须是砺镜砂',
    'execute unless data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run return 0',
    '# 影尘 ≥10',
    'execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute unless score #t count matches 10.. run return 0',
    '',
    '# 读当前锁位数',
    'execute store result score #t lock run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_lock',
    '',
    '# 掷骰：用 loot table 抽 3 条镜律（不重复），结果暂存到 #t law1..3',
    'function plm:mirror/table/roll',
    '',
    '# 写入未锁的槽位',
    'execute if score #t lock matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1 set value 0',
    'execute if score #t lock matches 0 run function plm:mirror/table/write_line1',
    'execute if score #t lock matches 1 run function plm:mirror/table/write_line2',
    'execute if score #t lock matches 2 run function plm:mirror/table/write_line3',
    '',
    '# 记录本次结果（供定影选择）',
    'function plm:mirror/table/write_last1',
    'function plm:mirror/table/write_last2',
    'function plm:mirror/table/write_last3',
    '',
    '# 扣材料',
    'data remove block ~ ~ ~ Items[{Slot:0b}]',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute if score #t count matches 10 run data remove block ~ ~ ~ Items[{Slot:8b}]',
    'execute if score #t count matches 11.. run data modify block ~ ~ ~ Items[{Slot:8b}].Count set value 1',
    '',
    '# 把结果放回输出位（玩家取回）',
    'item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3',
    'data remove block ~ ~ ~ Items[{Slot:3b}]',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 镜面一转——新的镜律已映出，请取回装备。","color":"aqua"}',
    'function plm:mirror/table/report_lines',
])

# 掷骰（简化：用随机数取模，避免依赖 loot table 的复杂度）
wf('roll.mcfunction', [
    '# 掷骰：三次独立随机，范围 1..24，简单去重（重复则 +1 循环）',
    'function plm:mirror/table/rand24',
    'scoreboard players operation #t law1 = #t rand',
    'function plm:mirror/table/rand24',
    'scoreboard players operation #t law2 = #t rand',
    'execute if score #t law2 = #t law1 run scoreboard players add #t law2 1',
    'execute if score #t law2 matches 25.. run scoreboard players set #t law2 1',
    'function plm:mirror/table/rand24',
    'scoreboard players operation #t law3 = #t rand',
    'execute if score #t law3 = #t law1 run scoreboard players add #t law3 1',
    'execute if score #t law3 = #t law2 run scoreboard players add #t law3 1',
    'execute if score #t law3 matches 25.. run scoreboard players set #t law3 1',
])

wf('rand24.mcfunction', [
    '# 生成 1..24 随机数到 #t rand',
    '# 1.20.1 没有 /random 命令，改用本体同款方案：item_modifier + luck 属性',
    'setblock ~ ~2 ~ minecraft:chest{Items:[{Slot:0b,id:"minecraft:stone",Count:1b}]} replace',
    'item modify block ~ ~2 ~ container.0 plm:rand24',
    'execute store result score #t rand run data get block ~ ~2 ~ Items[0].tag.AttributeModifiers[0].Amount 1',
    'setblock ~ ~2 ~ minecraft:air replace',
])

wf('write_line1.mcfunction', [
    'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t law1',
    'data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1 set from storage plm:tbl tmp',
])
wf('write_line2.mcfunction', [
    'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t law2',
    'data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line2 set from storage plm:tbl tmp',
])
wf('write_line3.mcfunction', [
    'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t law3',
    'data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line3 set from storage plm:tbl tmp',
])

# 提示本次结果
NAMES = ['回响', '映照', '破镜', '连影', '镜像', '静影', '逆影', '净镜', '影步', '重华',
         '碎影', '镜潮', '定影守', '观照', '拓印', '相克', '镜卫', '澈', '定影御', '映伤',
         '偏影', '薄镜', '蚀', '贪影']
lines = ['# 播报本次镜律结果']
for i, n in enumerate(NAMES, 1):
    lines.append('execute if score #t law1 matches %d run tellraw @s {"text":"  ① %s","color":"white"}' % (i, n))
for i, n in enumerate(NAMES, 1):
    lines.append('execute if score #t law2 matches %d run tellraw @s {"text":"  ② %s","color":"white"}' % (i, n))
for i, n in enumerate(NAMES, 1):
    lines.append('execute if score #t law3 matches %d run tellraw @s {"text":"  ③ %s","color":"white"}' % (i, n))
wf('report_lines.mcfunction', lines)
print('输出/磨镜逻辑已写入')
