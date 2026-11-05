# 统一色号：1 白 / 2 赤 / 3 青 / 4 黑
execute if score #arena mirror_summon_color matches 1 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_color_white
execute if score #arena mirror_summon_color matches 2 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_color_red
execute if score #arena mirror_summon_color matches 3 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_color_cyan
execute if score #arena mirror_summon_color matches 4 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_color_black
# 禁攻：颜色 == 当前顶部色 或 当前底部色
execute if score #arena mirror_summon_color matches 1 if score #arena mirror_top_color matches 1 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_forbidden
execute if score #arena mirror_summon_color matches 1 if score #arena mirror_bottom_color matches 2 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_forbidden
execute if score #arena mirror_summon_color matches 2 if score #arena mirror_top_color matches 2 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_forbidden
execute if score #arena mirror_summon_color matches 3 if score #arena mirror_top_color matches 3 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_forbidden
execute if score #arena mirror_summon_color matches 4 if score #arena mirror_bottom_color matches 1 run tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] add mirror_forbidden
# 其余为可攻
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new,tag=!mirror_forbidden] run tag @s add mirror_allowed
tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new] remove mirror_new
