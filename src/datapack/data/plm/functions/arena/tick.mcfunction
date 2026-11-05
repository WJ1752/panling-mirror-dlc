# @e 不附加 distance/dx，允许从主世界驱动找到异维度唯一锚点；at 随锚点切换维度。
execute unless score #arena mirror_arena_active matches 1 run return 0
execute at @e[type=minecraft:marker,tag=mirror_arena_anchor,limit=1] run function plm:arena/tick/room
execute if score #arena mirror_arena_active matches 1 unless entity @e[type=minecraft:marker,tag=mirror_arena_anchor,limit=1] run function plm:arena/room/missing
