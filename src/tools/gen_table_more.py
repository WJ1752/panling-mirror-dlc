# -*- coding: utf-8 -*-
"""生成磨镜台剩余动作：定影 / 映度 / 分解 + 镜律数据表 + 语言包"""
import io, os, json

DP = r'E:\梦回盘灵DLC开发\src\datapack'
RP = r'E:\梦回盘灵DLC开发\src\resourcepack'
F = os.path.join(DP, 'data/plm/functions/mirror/table')


def wf(rel, lines):
    p = os.path.join(F, rel)
    d = os.path.dirname(p)
    if d:
        os.makedirs(d, exist_ok=True)
    io.open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')


# ============ 定影 ============
wf('act/seal.mcfunction', [
    '# ---- 定影：槽3 镜装 + 槽1 定影符(壹/贰/叁) + 槽8 影尘×10 ----',
    'execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run return 0',
    '# 必须有定影符',
    'scoreboard players set #t seal_lvl 0',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t seal_lvl 1',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t seal_lvl 2',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t seal_lvl 3',
    'execute if score #t seal_lvl matches 0 run return 0',
    '',
    '# 影尘 ≥10',
    'execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute unless score #t count matches 10.. run return 0',
    '',
    '# 当前锁位数必须等于 符等级-1（壹锁第1条、贰锁第2条、叁锁第3条）',
    'execute store result score #t lock run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_lock',
    'scoreboard players operation #t need = #t seal_lvl',
    'scoreboard players remove #t need 1',
    'execute unless score #t lock = #t need run return 0',
    '',
    '# 把 mirror_lastN 固化为 mirror_lineN',
    'execute if score #t seal_lvl matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1 set from block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last1',
    'execute if score #t seal_lvl matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line2 set from block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last2',
    'execute if score #t seal_lvl matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line3 set from block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last3',
    'execute store result block ~ ~ ~ Items[{Slot:3b}].tag.mirror_lock int 1 run scoreboard players get #t seal_lvl',
    '',
    '# 扣材料',
    'data remove block ~ ~ ~ Items[{Slot:1b}]',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute if score #t count matches 10 run data remove block ~ ~ ~ Items[{Slot:8b}]',
    'execute if score #t count matches 11.. run data modify block ~ ~ ~ Items[{Slot:8b}].Count set value 1',
    '',
    '# 回输出位',
    'item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3',
    'data remove block ~ ~ ~ Items[{Slot:3b}]',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 定影成功——这条镜律从此不再改变。","color":"aqua"}',
])

# ============ 映度 ============
# 槽3 镜装 + 槽0 倒影核×N + 槽8 影尘×10；N = 当前映度+1
wf('act/degree.mcfunction', [
    '# ---- 映度：槽3 镜装 + 槽0 倒影核×N + 槽8 影尘×10 ----',
    'execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run return 0',
    'execute unless data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run return 0',
    'execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0',
    '',
    '# 当前映度必须 < 5',
    'execute store result score #t deg run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_degree',
    'execute if score #t deg matches 5.. run return 0',
    '',
    '# 映度 0→5 按 1+1+1+2+2 核收费',
    'scoreboard players set #t need 1',
    'execute if score #t deg matches 3.. run scoreboard players set #t need 2',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count',
    'execute if score #t count < #t need run return 0',
    '',
    '# 影尘 ≥10',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute if score #t count < 10 run return 0',
    '',
    '# 升映度',
    'scoreboard players add #t deg 1',
    'function plm:mirror/table/write_degree',
    '',
    '# 扣倒影核（精确扣 N 个）',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count',
    'scoreboard players operation #t left = #t count',
    'scoreboard players operation #t left -= #t need',
    'execute if score #t left matches 1.. run function plm:mirror/table/write_core_left',
    'execute if score #t left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]',
    '',
    '# 扣影尘 10',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'scoreboard players remove #t count 10',
    'execute if score #t count matches 1.. run function plm:mirror/table/write_dust_left',
    'execute if score #t count matches ..0 run data remove block ~ ~ ~ Items[{Slot:8b}]',
    '',
    '# 回输出位',
    'item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3',
    'data remove block ~ ~ ~ Items[{Slot:3b}]',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 映度提升——镜律数值随映度增强。","color":"aqua"}',
])

# ============ 分解 ============
# 槽3 镜装 → 回收 60% 材料（镜片 ×2 + 影尘 ×5），镜胚 100% 返还
wf('act/dissolve.mcfunction', [
    '# ---- 分解：槽3 镜装 → 返还镜胚 + 部分材料 ----',
    'execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run return 0',
    '',
    '# 判断器形，返还对应镜胚',
    'scoreboard players set #t kind 0',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sword7"}}] run scoreboard players set #t kind 1',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_axe7"}}] run scoreboard players set #t kind 2',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_bow7"}}] run scoreboard players set #t kind 3',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_crossbow7"}}] run scoreboard players set #t kind 4',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_twin7"}}] run scoreboard players set #t kind 5',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_rub7"}}] run scoreboard players set #t kind 6',
    '# 防具：按 id 里的套/部位还原（简化：统一返还对应部位胚）',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_zhao_1"}}] run scoreboard players set #t kind 11',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_zhao_2"}}] run scoreboard players set #t kind 12',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_zhao_3"}}] run scoreboard players set #t kind 13',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_zhao_4"}}] run scoreboard players set #t kind 14',
    'execute if score #t kind matches 0 run return 0',
    '',
    '# 返还（武器胚 100%，防具胚 100%，另加镜片×2 + 影尘×5）',
    'function plm:mirror/table/output/dissolve_return',
    '',
    '# 清掉镜装',
    'data remove block ~ ~ ~ Items[{Slot:3b}]',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 已分解：镜胚全额返还，另回收镜片×2、影尘×5。","color":"aqua"}',
])

# 返还物品
wf('output/dissolve_return.mcfunction', [
    '# 返还镜胚（进输出位）',
    'execute if score #t kind matches 1 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:flint",tag:{id:"panling:mirror_mold_sword",CustomModelData:370,display:{Name:\'{"translate":"pl.item.name.mirror_mold_sword"}\'}}}]}',
    'execute if score #t kind matches 2 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:flint",tag:{id:"panling:mirror_mold_axe",CustomModelData:371,display:{Name:\'{"translate":"pl.item.name.mirror_mold_axe"}\'}}}]}',
    'execute if score #t kind matches 3 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:flint",tag:{id:"panling:mirror_mold_bow",CustomModelData:372,display:{Name:\'{"translate":"pl.item.name.mirror_mold_bow"}\'}}}]}',
    'execute if score #t kind matches 4 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:flint",tag:{id:"panling:mirror_mold_crossbow",CustomModelData:373,display:{Name:\'{"translate":"pl.item.name.mirror_mold_crossbow"}\'}}}]}',
    'execute if score #t kind matches 5 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:flint",tag:{id:"panling:mirror_mold_furnace_twin",CustomModelData:374,display:{Name:\'{"translate":"pl.item.name.mirror_mold_furnace_twin"}\'}}}]}',
    'execute if score #t kind matches 6 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:flint",tag:{id:"panling:mirror_mold_furnace_rub",CustomModelData:375,display:{Name:\'{"translate":"pl.item.name.mirror_mold_furnace_rub"}\'}}}]}',
    'execute if score #t kind matches 11 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:charcoal",tag:{id:"panling:mirror_mold_helmet",CustomModelData:376,display:{Name:\'{"translate":"pl.item.name.mirror_mold_helmet"}\'}}}]}',
    'execute if score #t kind matches 12 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:charcoal",tag:{id:"panling:mirror_mold_chestplate",CustomModelData:377,display:{Name:\'{"translate":"pl.item.name.mirror_mold_chestplate"}\'}}}]}',
    'execute if score #t kind matches 13 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:charcoal",tag:{id:"panling:mirror_mold_leggings",CustomModelData:378,display:{Name:\'{"translate":"pl.item.name.mirror_mold_leggings"}\'}}}]}',
    'execute if score #t kind matches 14 run data merge block ~ ~ ~ {Items:[{Slot:5b,Count:1b,id:"minecraft:charcoal",tag:{id:"panling:mirror_mold_boots",CustomModelData:379,display:{Name:\'{"translate":"pl.item.name.mirror_mold_boots"}\'}}}]}',
])

# 写入辅助（避免 execute store result block 的非法写法）
wf('write_degree.mcfunction', [
    'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t deg',
    'data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_degree set from storage plm:tbl tmp',
])
wf('write_core_left.mcfunction', [
    'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t left',
    'data modify block ~ ~ ~ Items[{Slot:0b}].Count set from storage plm:tbl tmp',
])
wf('write_dust_left.mcfunction', [
    'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t count',
    'data modify block ~ ~ ~ Items[{Slot:8b}].Count set from storage plm:tbl tmp',
])

# ============ 镜律数据表 ============
LAWS = [
    (1, '回响', 'echo', '伤害的 20% 在 1.5s 后对同一目标再结算一次'),
    (2, '映照', 'reflect', '受击时对 5 格内攻击者反射 15% 伤害'),
    (3, '破镜', 'shatter', '击杀时对 3 格内敌人造成溢出伤害的 50%'),
    (4, '连影', 'chain', '对同一目标每第 3 次命中造成 150% 伤害'),
    (5, '镜像', 'mirror_cd', '武器技命中 3 个不同目标后冷却立即结束'),
    (6, '静影', 'still', '静止 2s 后下一次攻击 +30%'),
    (7, '逆影', 'reverse', '生命低于 35% 时武器技冷却 -40%'),
    (8, '净镜', 'cleanse', '受击时消耗 1 层负面效果并对 3 格内造成 40% 伤害'),
    (9, '影步', 'shadowstep', '潜行中每 5s 生成 1 个吸引仇恨的幻影'),
    (10, '重华', 'heavy', '对同一目标造成 3 种不同来源伤害后引爆，造成三者之和的 30%'),
    (11, '碎影', 'broken', '对带减速/眩晕/流血的目标伤害 +12%'),
    (12, '镜潮', 'tide', '每 30s 在脚下生成镜潮，3 格内敌人被推离并受 50% 伤害'),
    (13, '定影·守', 'guard', '受击后 1s 内抗击退 100%，叠 5% 减伤（上限 3 层）'),
    (14, '观照', 'observe', '每次格挡/反弹成功，为 5 格内队伍各回复 2% 最大生命'),
    (15, '拓印', 'rub', '击杀时额外获得拓片概率 +25%'),
    (16, '相克', 'counter', '用相克元素命中被相生标记的敌人时阵法强度 +20%'),
    (17, '镜卫', 'ward', '4 件套 2 件以上时，5 格内每有一名队友减伤 +3%'),
    (18, '澈', 'clear', '站在镜面方块上时移速 +10%、免疫击退'),
    (19, '定影·御', 'hold', '完全静止 3s 后获得吸收 15% 最大生命的护盾'),
    (20, '映伤', 'absorb', '受到的元素伤害 15% 转化为同元素抗性'),
    (21, '偏影', 'bias', '[负律] 暴击伤害 +25%，暴击率 -10%'),
    (22, '薄镜', 'thin', '[负律] 伤害 +12%，受到伤害 +6%'),
    (23, '蚀', 'corrode', '[负律] 武器技冷却 -20%，基础攻击 -8%'),
    (24, '贪影', 'greed', '[负律] 掉落 +20%，镜评 -1 档'),
]
lines = ['# 镜律数据表：编号 → 名称/键/描述（供提示、lore、后续效果实现引用）',
         '# 编号与 mirror_lineN 对应']
for n, cn, key, desc in LAWS:
    lines.append('scoreboard players set #law name_%d %d' % (n, n))
wf('law/table.mcfunction', lines)

# 语言包
lang = {
    'pl.lore.rare7': '§f§l稀有度:★★★★★★★[镜]',
    'pl.lore.mirror_degree0': '§f映度：§7※※※※※',
    'pl.lore.mirror_no_line': '§7∟尚无镜律（磨镜后出现）',
    'pl.item.name.mirror_sword7': '§f照心镜剑',
    'pl.item.name.mirror_axe7': '§f裂影镜斧',
    'pl.item.name.mirror_bow7': '§f镜花境弓',
    'pl.item.name.mirror_crossbow7': '§f残影镜弩',
    'pl.item.name.mirror_furnace_twin7': '§f双生镜炉',
    'pl.item.name.mirror_furnace_rub7': '§f拓印镜炉',
    'pl.item.name.mirror_shard_metal': '§b镜片·金',
    'pl.item.name.mirror_shard_wood': '§b镜片·木',
    'pl.item.name.mirror_shard_water': '§b镜片·水',
    'pl.item.name.mirror_shard_fire': '§b镜片·火',
    'pl.item.name.mirror_shard_earth': '§b镜片·土',
    'pl.item.name.mirror_heart_metal': '§d镜心·金',
    'pl.item.name.mirror_heart_wood': '§d镜心·木',
    'pl.item.name.mirror_heart_water': '§d镜心·水',
    'pl.item.name.mirror_heart_fire': '§d镜心·火',
    'pl.item.name.mirror_heart_earth': '§d镜心·土',
    'pl.item.name.mirror_mold_sword': '§e镜胚·剑',
    'pl.item.name.mirror_mold_axe': '§e镜胚·斧',
    'pl.item.name.mirror_mold_bow': '§e镜胚·弓',
    'pl.item.name.mirror_mold_crossbow': '§e镜胚·弩',
    'pl.item.name.mirror_mold_furnace_twin': '§e镜胚·双生炉',
    'pl.item.name.mirror_mold_furnace_rub': '§e镜胚·拓印炉',
    'pl.item.name.mirror_mold_helmet': '§e镜胚·盔',
    'pl.item.name.mirror_mold_chestplate': '§e镜胚·甲',
    'pl.item.name.mirror_mold_leggings': '§e镜胚·腿',
    'pl.item.name.mirror_mold_boots': '§e镜胚·靴',
    'pl.item.name.mirror_edge_zhao': '§a镜缘·照心',
    'pl.item.name.mirror_edge_lie': '§a镜缘·裂影',
    'pl.item.name.mirror_edge_jing': '§a镜缘·镜花',
    'pl.item.name.mirror_edge_can': '§a镜缘·残影',
    'pl.item.name.mirror_edge_twin': '§a镜缘·双生',
    'pl.item.name.mirror_edge_rub': '§a镜缘·拓印',
    'pl.item.name.mirror_dust': '§7影尘',
    'pl.item.name.mirror_sand': '§f砺镜砂',
    'pl.item.name.mirror_seal_1': '§9定影符·壹',
    'pl.item.name.mirror_seal_2': '§9定影符·贰',
    'pl.item.name.mirror_seal_3': '§9定影符·叁',
    'pl.item.name.mirror_seal_rev': '§5定影符·反',
    'pl.item.name.mirror_core': '§5倒影核',
}
for si, (skey, scn) in enumerate([('zhao', '照心'), ('lie', '裂影'), ('jing', '镜花'),
                                  ('can', '残影'), ('twin', '双生'), ('rub', '拓印')]):
    for pi, pcn in enumerate(['盔', '甲', '腿', '靴'], 1):
        lang['pl.item.name.mirror_%s_%d' % (skey, pi)] = '§f%s镜·%s' % (scn, pcn)

p = os.path.join(RP, 'assets/lang_mirror/lang/zh_cn.json')
os.makedirs(os.path.dirname(p), exist_ok=True)
io.open(p, 'w', encoding='utf-8', newline='\n').write(json.dumps(lang, ensure_ascii=False, indent=2))
print('剩余动作 + 镜律表 + 语言包已写入（%d 个键）' % len(lang))
