# 禁攻黑色粒子 / 可攻白色粒子
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_forbidden] at @s run particle minecraft:large_smoke ~ ~2.2 ~ 0.15 0.15 0.15 0.01 2
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_allowed] at @s run particle minecraft:end_rod ~ ~2.2 ~ 0.15 0.15 0.15 0.01 2
