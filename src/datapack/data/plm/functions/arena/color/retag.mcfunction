# 颜色轮换后重新标记所有存活召唤物
tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon] remove mirror_forbidden
tag @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon] remove mirror_allowed
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_color_white] if score #arena mirror_top_color matches 1 run tag @s add mirror_forbidden
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_color_white] if score #arena mirror_bottom_color matches 2 run tag @s add mirror_forbidden
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_color_red] if score #arena mirror_top_color matches 2 run tag @s add mirror_forbidden
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_color_cyan] if score #arena mirror_top_color matches 3 run tag @s add mirror_forbidden
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=mirror_color_black] if score #arena mirror_bottom_color matches 1 run tag @s add mirror_forbidden
execute as @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon,tag=!mirror_forbidden] run tag @s add mirror_allowed
