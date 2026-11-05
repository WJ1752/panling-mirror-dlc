# 放印视觉：4 格金色拓印阵（@s = 玩家）
# 每 5 tick ≤ 60 条命令：1 条中心 + 8 个环点 + 1 条上升柱 + 2 个音效
execute at @s run particle minecraft:dust 1 0.82 0.25 1.2 ~ ~0.15 ~ 0.45 0.05 0.45 0.01 30
execute at @s positioned ~4 ~ ~ run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~-4 ~ ~ run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~ ~ ~4 run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~ ~ ~-4 run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~2.83 ~ ~2.83 run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~2.83 ~ ~-2.83 run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~-2.83 ~ ~2.83 run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s positioned ~-2.83 ~ ~-2.83 run particle minecraft:dust 1 0.82 0.25 1 ~ ~0.2 ~ 0 0 0 0.01 3
execute at @s run particle minecraft:end_rod ~ ~0.4 ~ 0.25 0.25 0.25 0.04 12
execute at @s run playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 1 0.9
execute at @s run playsound minecraft:entity.evoker.cast_spell master @a ~ ~ ~ 0.7 1.3
