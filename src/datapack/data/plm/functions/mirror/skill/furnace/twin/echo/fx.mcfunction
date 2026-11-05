# 倒影阵视觉：颜色按相克元素（1 金 / 2 木 / 3 水 / 4 火 / 5 土），位置 = 阵中心。
execute if score #tw_el mirror_skill_tmp3 matches 1 run particle minecraft:dust 1 0.84 0.2 1 ~ ~1 ~ 1.3 0.5 1.3 0.02 30
execute if score #tw_el mirror_skill_tmp3 matches 2 run particle minecraft:dust 0.3 0.9 0.3 1 ~ ~1 ~ 1.3 0.5 1.3 0.02 30
execute if score #tw_el mirror_skill_tmp3 matches 3 run particle minecraft:dust 0.3 0.6 1 1 ~ ~1 ~ 1.3 0.5 1.3 0.02 30
execute if score #tw_el mirror_skill_tmp3 matches 4 run particle minecraft:dust 1 0.3 0.1 1 ~ ~1 ~ 1.3 0.5 1.3 0.02 30
execute if score #tw_el mirror_skill_tmp3 matches 5 run particle minecraft:dust 0.8 0.5 0.2 1 ~ ~1 ~ 1.3 0.5 1.3 0.02 30
# 用执行位置（阵中心）播音，不要 at @s（@s 是主人玩家）
playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 0.8 1.1