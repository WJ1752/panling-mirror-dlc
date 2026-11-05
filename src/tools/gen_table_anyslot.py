# -*- coding: utf-8 -*-
"""重写磨镜台：改为「任意槽位」识别（玩家怎么放都能用）
   规则：投掷器 9 格里，按 id 找齐所需材料，不看槽位。
   输出写到槽 5，已有物品时拒绝执行。
"""
import io, os

DP = r'E:\梦回盘灵DLC开发\src\datapack'
F = os.path.join(DP, 'data/plm/functions/mirror/table')


def wf(rel, lines):
    p = os.path.join(F, rel)
    d = os.path.dirname(p)
    if d:
        os.makedirs(d, exist_ok=True)
    io.open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')


# ---------- 槽位扫描：把 9 格里的物品按 id 归到 #t 的槽号记录 ----------
# 用 9 条独立判定，每条记录「某类材料在哪个槽、有几个」
SCAN = ['# 扫描投掷器 9 格，记录各类材料的槽位与数量（0..8）']
KINDS = [
    ('mold_sword', 'panling:mirror_mold_sword'),
    ('mold_axe', 'panling:mirror_mold_axe'),
    ('mold_bow', 'panling:mirror_mold_bow'),
    ('mold_crossbow', 'panling:mirror_mold_crossbow'),
    ('mold_twin', 'panling:mirror_mold_furnace_twin'),
    ('mold_rub', 'panling:mirror_mold_furnace_rub'),
    ('mold_helmet', 'panling:mirror_mold_helmet'),
    ('mold_chest', 'panling:mirror_mold_chestplate'),
    ('mold_legs', 'panling:mirror_mold_leggings'),
    ('mold_boots', 'panling:mirror_mold_boots'),
    ('heart_metal', 'panling:mirror_heart_metal'),
    ('heart_wood', 'panling:mirror_heart_wood'),
    ('heart_water', 'panling:mirror_heart_water'),
    ('heart_fire', 'panling:mirror_heart_fire'),
    ('heart_earth', 'panling:mirror_heart_earth'),
    ('shard_metal', 'panling:mirror_shard_metal'),
    ('shard_wood', 'panling:mirror_shard_wood'),
    ('shard_water', 'panling:mirror_shard_water'),
    ('shard_fire', 'panling:mirror_shard_fire'),
    ('shard_earth', 'panling:mirror_shard_earth'),
    ('edge_zhao', 'panling:mirror_edge_zhao'),
    ('edge_lie', 'panling:mirror_edge_lie'),
    ('edge_jing', 'panling:mirror_edge_jing'),
    ('edge_can', 'panling:mirror_edge_can'),
    ('edge_twin', 'panling:mirror_edge_twin'),
    ('edge_rub', 'panling:mirror_edge_rub'),
    ('dust', 'panling:mirror_dust'),
    ('sand', 'panling:mirror_sand'),
    ('seal1', 'panling:mirror_seal_1'),
    ('seal2', 'panling:mirror_seal_2'),
    ('seal3', 'panling:mirror_seal_3'),
    ('core', 'panling:mirror_core'),
    ('gear', '__MIRROR_GEAR__'),      # 任意镜装（mirror:1）
]
for key, mid in KINDS:
    SCAN.append('# %s' % key)
    SCAN.append('scoreboard players set #t cnt_%s 0' % key)
    SCAN.append('scoreboard players set #t num_%s 0' % key)
    SCAN.append('scoreboard players set #t slot_%s -1' % key)
    for s in range(9):
        if mid == '__MIRROR_GEAR__':
            cond = 'Items[{Slot:%db,tag:{mirror:1}}]' % s
        else:
            cond = 'Items[{Slot:%db,tag:{id:"%s"}}]' % (s, mid)
        SCAN.append('execute if data block ~ ~ ~ %s run scoreboard players set #t slot_%s %d' % (cond, key, s))
        SCAN.append('execute if data block ~ ~ ~ %s run scoreboard players set #t cnt_%s %d' % (cond, key, 1))
        # 记录数量
        SCAN.append('execute if data block ~ ~ ~ %s store result score #t num_%s run data get block ~ ~ ~ Items[{Slot:%db}].Count' % (cond, key, s))
wf('scan.mcfunction', SCAN)

# ---------- 工具：按槽号删除物品 ----------
DEL = ['# 按 #t 记录的槽号删除物品']
for key, _ in KINDS:
    for s in range(9):
        DEL.append('execute if score #t slot_%s matches %d run data remove block ~ ~ ~ Items[{Slot:%db}]' % (key, s, s))
wf('del_by_slot.mcfunction', DEL)

# ---------- 主入口 ----------
wf('main.mcfunction', [
    '# 磨镜台入口（任意槽位识别版）',
    'execute if score @s mirror_tbl_cool matches 1.. run return 0',
    'scoreboard players set @s mirror_tbl_cool 10',
    '',
    'execute unless block ~ ~ ~ minecraft:dropper run tellraw @s {"text":"[磨镜台] 找不到投掷器。","color":"red"}',
    'execute unless block ~ ~ ~ minecraft:dropper run return 0',
    '',
    '# 保护输出位（槽5），重置临时状态',
    'scoreboard players set #t success 0',
    'execute if data block ~ ~ ~ Items[{Slot:5b}] run tellraw @s {"text":"[磨镜台] 请先取走输出槽（第 6 格）的物品。","color":"yellow"}',
    'execute if data block ~ ~ ~ Items[{Slot:5b}] run return 0',
    '',
    '# 扫描全部槽位',
    'function plm:mirror/table/scan',
    '',
    '# 依次尝试',
    'execute if score #t success matches 0 run function plm:mirror/table/act/assemble',
    'execute if score #t success matches 0 run function plm:mirror/table/act/polish',
    'execute if score #t success matches 0 run function plm:mirror/table/act/seal',
    'execute if score #t success matches 0 run function plm:mirror/table/act/degree',
    'execute if score #t success matches 0 run function plm:mirror/table/act/dissolve',
    '',
    'execute if score #t success matches 0 run tellraw @s {"text":"[磨镜台] 材料不匹配。需要：镜胚+镜心+镜片+影尘（拼镜），或 镜装+砺镜砂+影尘（磨镜）。","color":"gray"}',
    'scoreboard players set #t success 0',
    'function plm:mirror/table/cleanup',
])

# ---------- 拼镜（任意槽位） ----------
wf('act/assemble.mcfunction', [
    '# 拼镜：需要 1 个镜胚 + 镜心(3武器/2防具) + 镜片(4武器/2防具) + 影尘≥20',
    '# 判定是否有镜胚',
    'scoreboard players set #t has_mold 0',
    'execute if score #t cnt_mold_sword matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_axe matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_bow matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_crossbow matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_twin matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_rub matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_helmet matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_chest matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_legs matches 1 run scoreboard players set #t has_mold 1',
    'execute if score #t cnt_mold_boots matches 1 run scoreboard players set #t has_mold 1',
    'execute unless score #t has_mold matches 1 run return 0',
    '',
    '# 判定元素（哪种镜心有 2 个以上）',
    'scoreboard players set #t elem -1',
    'execute if score #t num_heart_metal matches 2.. run scoreboard players set #t elem 0',
    'execute if score #t num_heart_wood matches 2.. run scoreboard players set #t elem 1',
    'execute if score #t num_heart_water matches 2.. run scoreboard players set #t elem 2',
    'execute if score #t num_heart_fire matches 2.. run scoreboard players set #t elem 3',
    'execute if score #t num_heart_earth matches 2.. run scoreboard players set #t elem 4',
    'execute unless score #t elem matches 0.. run return 0',
    '',
    '# 判定武器还是防具（有武器胚 → 武器）',
    'scoreboard players set #t is_weapon 0',
    'execute if score #t cnt_mold_sword matches 1 run scoreboard players set #t is_weapon 1',
    'execute if score #t cnt_mold_axe matches 1 run scoreboard players set #t is_weapon 1',
    'execute if score #t cnt_mold_bow matches 1 run scoreboard players set #t is_weapon 1',
    'execute if score #t cnt_mold_crossbow matches 1 run scoreboard players set #t is_weapon 1',
    'execute if score #t cnt_mold_twin matches 1 run scoreboard players set #t is_weapon 1',
    'execute if score #t cnt_mold_rub matches 1 run scoreboard players set #t is_weapon 1',
    '',
    'execute if score #t is_weapon matches 1 run function plm:mirror/table/act/assemble_weapon',
    'execute if score #t is_weapon matches 0 run function plm:mirror/table/act/assemble_armor',
])

wf('act/assemble_weapon.mcfunction', [
    '# 武器拼镜：镜心必须 ≥3，镜片 ≥4，影尘 ≥20',
    '# 找对应元素的镜心数量与镜片数量',
    'scoreboard players set #t need_heart 3',
    'scoreboard players set #t need_shard 4',
    '',
    '# 按元素取数量',
    'scoreboard players set #t have_heart 0',
    'scoreboard players set #t have_shard 0',
    'execute if score #t elem matches 0 run scoreboard players operation #t have_heart = #t num_heart_metal',
    'execute if score #t elem matches 1 run scoreboard players operation #t have_heart = #t num_heart_wood',
    'execute if score #t elem matches 2 run scoreboard players operation #t have_heart = #t num_heart_water',
    'execute if score #t elem matches 3 run scoreboard players operation #t have_heart = #t num_heart_fire',
    'execute if score #t elem matches 4 run scoreboard players operation #t have_heart = #t num_heart_earth',
    'execute if score #t elem matches 0 run scoreboard players operation #t have_shard = #t num_shard_metal',
    'execute if score #t elem matches 1 run scoreboard players operation #t have_shard = #t num_shard_wood',
    'execute if score #t elem matches 2 run scoreboard players operation #t have_shard = #t num_shard_water',
    'execute if score #t elem matches 3 run scoreboard players operation #t have_shard = #t num_shard_fire',
    'execute if score #t elem matches 4 run scoreboard players operation #t have_shard = #t num_shard_earth',
    '',
    'execute if score #t have_heart < 3 run return 0',
    'execute if score #t have_shard < 4 run return 0',
    'execute if score #t num_dust < 20 run return 0',
    '',
    '# 器形',
    'scoreboard players set #t kind 0',
    'execute if score #t cnt_mold_sword matches 1 run scoreboard players set #t kind 1',
    'execute if score #t cnt_mold_axe matches 1 run scoreboard players set #t kind 2',
    'execute if score #t cnt_mold_bow matches 1 run scoreboard players set #t kind 3',
    'execute if score #t cnt_mold_crossbow matches 1 run scoreboard players set #t kind 4',
    'execute if score #t cnt_mold_twin matches 1 run scoreboard players set #t kind 5',
    'execute if score #t cnt_mold_rub matches 1 run scoreboard players set #t kind 6',
    '',
    'function plm:mirror/table/output/weapon',
    '',
    '# 扣材料：镜胚 1、镜心 3、镜片 4、影尘 20',
    'function plm:mirror/table/consume_weapon',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 拼镜完成——镜装已出现在右下角输出格。","color":"aqua"}',
])

wf('act/assemble_armor.mcfunction', [
    '# 防具拼镜：镜心 ≥2，镜片 ≥2，镜缘 1，影尘 ≥20',
    'scoreboard players set #t have_heart 0',
    'scoreboard players set #t have_shard 0',
    'execute if score #t elem matches 0 run scoreboard players operation #t have_heart = #t num_heart_metal',
    'execute if score #t elem matches 1 run scoreboard players operation #t have_heart = #t num_heart_wood',
    'execute if score #t elem matches 2 run scoreboard players operation #t have_heart = #t num_heart_water',
    'execute if score #t elem matches 3 run scoreboard players operation #t have_heart = #t num_heart_fire',
    'execute if score #t elem matches 4 run scoreboard players operation #t have_heart = #t num_heart_earth',
    'execute if score #t elem matches 0 run scoreboard players operation #t have_shard = #t num_shard_metal',
    'execute if score #t elem matches 1 run scoreboard players operation #t have_shard = #t num_shard_wood',
    'execute if score #t elem matches 2 run scoreboard players operation #t have_shard = #t num_shard_water',
    'execute if score #t elem matches 3 run scoreboard players operation #t have_shard = #t num_shard_fire',
    'execute if score #t elem matches 4 run scoreboard players operation #t have_shard = #t num_shard_earth',
    'execute if score #t have_heart < 2 run return 0',
    'execute if score #t have_shard < 2 run return 0',
    'execute if score #t num_dust < 20 run return 0',
    '',
    '# 镜缘（必须有一种）',
    'scoreboard players set #t edge -1',
    'execute if score #t cnt_edge_zhao matches 1 run scoreboard players set #t edge 0',
    'execute if score #t cnt_edge_lie matches 1 run scoreboard players set #t edge 1',
    'execute if score #t cnt_edge_jing matches 1 run scoreboard players set #t edge 2',
    'execute if score #t cnt_edge_can matches 1 run scoreboard players set #t edge 3',
    'execute if score #t cnt_edge_twin matches 1 run scoreboard players set #t edge 4',
    'execute if score #t cnt_edge_rub matches 1 run scoreboard players set #t edge 5',
    'execute unless score #t edge matches 0.. run return 0',
    '',
    '# 部位',
    'scoreboard players set #t part 0',
    'execute if score #t cnt_mold_helmet matches 1 run scoreboard players set #t part 0',
    'execute if score #t cnt_mold_chest matches 1 run scoreboard players set #t part 1',
    'execute if score #t cnt_mold_legs matches 1 run scoreboard players set #t part 2',
    'execute if score #t cnt_mold_boots matches 1 run scoreboard players set #t part 3',
    '',
    'function plm:mirror/table/output/armor',
    'function plm:mirror/table/consume_armor',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 拼镜完成——镜装已出现在右下角输出格。","color":"aqua"}',
])

# ---------- 扣材料 ----------
wf('consume_weapon.mcfunction', [
    '# 扣：镜胚1 镜心3 镜片4 影尘20（按扫描记录的槽号）',
    'execute if score #t cnt_mold_sword matches 1 run function plm:mirror/table/take/mold_sword',
    'execute if score #t cnt_mold_axe matches 1 run function plm:mirror/table/take/mold_axe',
    'execute if score #t cnt_mold_bow matches 1 run function plm:mirror/table/take/mold_bow',
    'execute if score #t cnt_mold_crossbow matches 1 run function plm:mirror/table/take/mold_crossbow',
    'execute if score #t cnt_mold_twin matches 1 run function plm:mirror/table/take/mold_twin',
    'execute if score #t cnt_mold_rub matches 1 run function plm:mirror/table/take/mold_rub',
    'execute if score #t elem matches 0 run function plm:mirror/table/take/heart_metal_3',
    'execute if score #t elem matches 1 run function plm:mirror/table/take/heart_wood_3',
    'execute if score #t elem matches 2 run function plm:mirror/table/take/heart_water_3',
    'execute if score #t elem matches 3 run function plm:mirror/table/take/heart_fire_3',
    'execute if score #t elem matches 4 run function plm:mirror/table/take/heart_earth_3',
    'execute if score #t elem matches 0 run function plm:mirror/table/take/shard_metal_4',
    'execute if score #t elem matches 1 run function plm:mirror/table/take/shard_wood_4',
    'execute if score #t elem matches 2 run function plm:mirror/table/take/shard_water_4',
    'execute if score #t elem matches 3 run function plm:mirror/table/take/shard_fire_4',
    'execute if score #t elem matches 4 run function plm:mirror/table/take/shard_earth_4',
    'function plm:mirror/table/take/dust_20',
])

wf('consume_armor.mcfunction', [
    '# 扣：镜胚1 镜心2 镜片2 镜缘1 影尘20',
    'execute if score #t cnt_mold_helmet matches 1 run function plm:mirror/table/take/mold_helmet',
    'execute if score #t cnt_mold_chest matches 1 run function plm:mirror/table/take/mold_chest',
    'execute if score #t cnt_mold_legs matches 1 run function plm:mirror/table/take/mold_legs',
    'execute if score #t cnt_mold_boots matches 1 run function plm:mirror/table/take/mold_boots',
    'execute if score #t elem matches 0 run function plm:mirror/table/take/heart_metal_2',
    'execute if score #t elem matches 1 run function plm:mirror/table/take/heart_wood_2',
    'execute if score #t elem matches 2 run function plm:mirror/table/take/heart_water_2',
    'execute if score #t elem matches 3 run function plm:mirror/table/take/heart_fire_2',
    'execute if score #t elem matches 4 run function plm:mirror/table/take/heart_earth_2',
    'execute if score #t elem matches 0 run function plm:mirror/table/take/shard_metal_2',
    'execute if score #t elem matches 1 run function plm:mirror/table/take/shard_wood_2',
    'execute if score #t elem matches 2 run function plm:mirror/table/take/shard_water_2',
    'execute if score #t elem matches 3 run function plm:mirror/table/take/shard_fire_2',
    'execute if score #t elem matches 4 run function plm:mirror/table/take/shard_earth_2',
    'execute if score #t edge matches 0 run function plm:mirror/table/take/edge_zhao',
    'execute if score #t edge matches 1 run function plm:mirror/table/take/edge_lie',
    'execute if score #t edge matches 2 run function plm:mirror/table/take/edge_jing',
    'execute if score #t edge matches 3 run function plm:mirror/table/take/edge_can',
    'execute if score #t edge matches 4 run function plm:mirror/table/take/edge_twin',
    'execute if score #t edge matches 5 run function plm:mirror/table/take/edge_rub',
    'function plm:mirror/table/take/dust_20',
])

# ---------- take 原子函数 ----------
def take(key, n):
    """生成：从该材料所在槽扣除 n 个"""
    lines = ['# 从 %s 所在槽扣除 %d 个' % (key, n)]
    for s in range(9):
        lines.append('execute if score #t slot_%s matches %d run scoreboard players operation #t tmp = #t num_%s' % (key, s, key))
        lines.append('execute if score #t slot_%s matches %d run scoreboard players remove #t tmp %d' % (key, s, n))
        lines.append('execute if score #t slot_%s matches %d if score #t tmp matches 1.. run function plm:mirror/table/take/set_%d' % (key, s, s))
        lines.append('execute if score #t slot_%s matches %d if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:%db}]' % (key, s, s))
    return lines

TAKES = [('mold_sword', 1), ('mold_axe', 1), ('mold_bow', 1), ('mold_crossbow', 1),
         ('mold_twin', 1), ('mold_rub', 1), ('mold_helmet', 1), ('mold_chest', 1),
         ('mold_legs', 1), ('mold_boots', 1),
         ('heart_metal_3', 3), ('heart_wood_3', 3), ('heart_water_3', 3), ('heart_fire_3', 3), ('heart_earth_3', 3),
         ('heart_metal_2', 2), ('heart_wood_2', 2), ('heart_water_2', 2), ('heart_fire_2', 2), ('heart_earth_2', 2),
         ('shard_metal_4', 4), ('shard_wood_4', 4), ('shard_water_4', 4), ('shard_fire_4', 4), ('shard_earth_4', 4),
         ('shard_metal_2', 2), ('shard_wood_2', 2), ('shard_water_2', 2), ('shard_fire_2', 2), ('shard_earth_2', 2),
         ('edge_zhao', 1), ('edge_lie', 1), ('edge_jing', 1), ('edge_can', 1), ('edge_twin', 1), ('edge_rub', 1),
         ('dust_20', 20), ('dust_10', 10), ('sand', 1), ('core', 1)]
for key, n in TAKES:
    base = key.rsplit('_', 1)[0] if key.rsplit('_', 1)[-1].isdigit() else key
    wf('take/%s.mcfunction' % key, take(base, n))

# set_N：把扣除后的数量写回槽 N
for s in range(9):
    lines = ['# 把 #t tmp 写回槽 %d 的 Count' % s,
             'execute store result storage plm:tbl tmp int 1 run scoreboard players get #t tmp',
             'data modify block ~ ~ ~ Items[{Slot:%db}].Count set from storage plm:tbl tmp' % s]
    wf('take/set_%d.mcfunction' % s, lines)

print('任意槽位版磨镜台已生成')
