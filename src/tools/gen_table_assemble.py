# -*- coding: utf-8 -*-
"""生成磨镜台：五动作（拼镜/磨镜/定影/映度/分解）
   槽位语义（design §5.3）：
     0 消耗位一   1 消耗位二   3 核心位   5 输出位   6 属性位   8 货币位
"""
import io, os

DP = r'E:\梦回盘灵DLC开发\src\datapack'
F = os.path.join(DP, 'data/plm/functions/mirror/table')


def w(rel, text):
    p = os.path.join(F, rel)
    d = os.path.dirname(p)
    if d:
        os.makedirs(d, exist_ok=True)
    io.open(p, 'w', encoding='utf-8', newline='\n').write(text)


def wf(rel, lines):
    w(rel, '\n'.join(lines) + '\n')


# ============ 入口：分派 ============
wf('main.mcfunction', [
    '# 磨镜台入口：由命令方块调用，@s = 操作玩家（命令方块需 execute as 玩家）',
    '# 前置：调用方需已 positioned 到投掷器坐标',
    '',
    '# 0) 环境检查：确认上方是 dropper',
    'execute unless block ~ ~ ~ minecraft:dropper run tellraw @s {"text":"[磨镜台] 找不到投掷器。","color":"red"}',
    'execute unless block ~ ~ ~ minecraft:dropper run return 0',
    '',
    'execute if data block ~ ~ ~ Items[{Slot:5b}] run tellraw @s {"text":"[磨镜台] 请先取走输出槽（第 6 格）的物品。","color":"yellow"}',
    'execute if data block ~ ~ ~ Items[{Slot:5b}] run return 0',
    '# 1) 清理临时标记',
    'function plm:mirror/table/reset',
    '',
    '# 2) 依次尝试五种动作（先匹配者生效，用 success 门闩）',
    'execute if score #t success matches 0 run function plm:mirror/table/act/assemble',
    'execute if score #t success matches 0 run function plm:mirror/table/act/polish',
    'execute if score #t success matches 0 run function plm:mirror/table/act/seal',
    'execute if score #t success matches 0 run function plm:mirror/table/act/degree',
    'execute if score #t success matches 0 run function plm:mirror/table/act/dissolve',
    '',
    '# 3) 没有匹配 → 提示',
    'execute if score #t success matches 0 run tellraw @s {"text":"[磨镜台] 材料组合不匹配。把材料放进投掷器后按按钮。","color":"gray"}',
    '',
    '# 4) 收尾',
    'scoreboard players set #t success 0',
    'function plm:mirror/table/cleanup',
])

# ============ reset / cleanup ============
wf('reset.mcfunction', [
    '# 每次执行前重置临时状态',
    'scoreboard players set #t success 0',
    'scoreboard players set #t tmp 0',
    'scoreboard players set #t tmp2 0',
    'scoreboard players set #t count 0',
])

wf('cleanup.mcfunction', [
    '# 播放反馈音效（成功/失败）',
    'execute if score #t success matches 1 run playsound minecraft:block.amethyst_block.chime master @s ~ ~ ~ 1 1.4',
    'execute if score #t success matches 0 run playsound minecraft:block.glass.break master @s ~ ~ ~ 0.6 0.8',
    'scoreboard players set #t success 0',
])

# ============ 动作 1：拼镜 ============
# 条件：槽3=镜胚, 槽6=镜心×3(同元素) 或 镜心×2+镜缘×1(防具), 槽0=镜片×4(武器)/×2(防具), 槽8=影尘×20
wf('act/assemble.mcfunction', [
    '# ---- 拼镜：判定镜胚（槽3） ----',
    'execute store result score #t mold_weapon run data get block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}].Count',
    'execute store result score #t mold_armor run data get block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_helmet"}}].Count',
    '',
    '# 有武器胚 → 走武器配方',
    'execute if score #t mold_weapon matches 1 run function plm:mirror/table/act/assemble_weapon',
    '# 有防具胚 → 走防具配方',
    'execute if score #t mold_armor matches 1 run function plm:mirror/table/act/assemble_armor',
])

wf('act/assemble_weapon.mcfunction', [
    '# 武器拼镜：镜胚×1 + 镜心×3(同元素) + 镜片×4(同元素) + 影尘×20',
    '# 判定镜心数量与元素',
    'scoreboard players set #t elem -1',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t elem 0',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t elem 1',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t elem 2',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t elem 3',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t elem 4',
    '',
    '# 镜心必须 3 个',
    'execute if score #t elem matches 0.. store result score #t count run data get block ~ ~ ~ Items[{Slot:6b}].Count',
    'execute unless score #t count matches 3 run return 0',
    '',
    '# 镜片 4 个（同元素）',
    'scoreboard players set #t ok 0',
    'execute if score #t elem matches 0 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 1 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 2 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 3 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 4 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t ok 1',
    'execute unless score #t ok matches 1 run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count',
    'execute unless score #t count matches 4.. run return 0',
    '',
    '# 影尘 ≥20',
    'execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute unless score #t count matches 20.. run return 0',
    '',
    '# 判定具体器形 → 输出对应镜装',
    'scoreboard players set #t kind 0',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t kind 1',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t kind 2',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t kind 3',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t kind 4',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t kind 5',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t kind 6',
    '',
    'function plm:mirror/table/output/weapon',
    '',
    '# 扣材料（镜胚1 镜心3 镜片4 影尘20）',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count',
    'execute if score #t count matches 4 run data remove block ~ ~ ~ Items[{Slot:0b}]',
    'execute if score #t count matches 5.. run data modify block ~ ~ ~ Items[{Slot:0b}].Count set value 1',
    'data remove block ~ ~ ~ Items[{Slot:3b}]',
    'data remove block ~ ~ ~ Items[{Slot:6b}]',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute if score #t count matches 20 run data remove block ~ ~ ~ Items[{Slot:8b}]',
    'execute if score #t count matches 21.. run data modify block ~ ~ ~ Items[{Slot:8b}].Count set value 1',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 拼镜完成：镜装已放入输出位。","color":"aqua"}',
])

wf('act/assemble_armor.mcfunction', [
    '# 防具拼镜：镜胚×1 + 镜心×2(同元素) + 镜缘×1 + 镜片×2(同元素) + 影尘×20',
    'scoreboard players set #t elem -1',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t elem 0',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t elem 1',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t elem 2',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t elem 3',
    'execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t elem 4',
    'execute unless score #t elem matches 0.. run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:6b}].Count',
    'execute unless score #t count matches 2.. run return 0',
    '',
    '# 镜缘必须在槽1',
    'scoreboard players set #t edge -1',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t edge 0',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t edge 1',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t edge 2',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t edge 3',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t edge 4',
    'execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t edge 5',
    'execute unless score #t edge matches 0.. run return 0',
    '',
    '# 镜片 2 个（同元素）',
    'scoreboard players set #t ok 0',
    'execute if score #t elem matches 0 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 1 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 2 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 3 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t ok 1',
    'execute if score #t elem matches 4 if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t ok 1',
    'execute unless score #t ok matches 1 run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count',
    'execute unless score #t count matches 2.. run return 0',
    '',
    '# 影尘 ≥20',
    'execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute unless score #t count matches 20.. run return 0',
    '',
    '# 部位',
    'scoreboard players set #t part 0',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t part 0',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t part 1',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t part 2',
    'execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t part 3',
    '',
    'function plm:mirror/table/output/armor',
    '',
    '# 扣材料',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count',
    'execute if score #t count matches 2 run data remove block ~ ~ ~ Items[{Slot:0b}]',
    'execute if score #t count matches 3.. run data modify block ~ ~ ~ Items[{Slot:0b}].Count set value 1',
    'data remove block ~ ~ ~ Items[{Slot:1b}]',
    'data remove block ~ ~ ~ Items[{Slot:3b}]',
    'data remove block ~ ~ ~ Items[{Slot:6b}]',
    'execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count',
    'execute if score #t count matches 20 run data remove block ~ ~ ~ Items[{Slot:8b}]',
    'execute if score #t count matches 21.. run data modify block ~ ~ ~ Items[{Slot:8b}].Count set value 1',
    '',
    'scoreboard players set #t success 1',
    'tellraw @s {"text":"[磨镜台] 拼镜完成：镜装已放入输出位。","color":"aqua"}',
])
print('拼镜逻辑已写入')
