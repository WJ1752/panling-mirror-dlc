execute positioned ~-22.5 ~-0.5 ~-22.5 unless entity @e[type=minecraft:marker,tag=mirror_arena_anchor,dx=45,dy=0,dz=45] run return 0
execute unless block ~ ~-1 ~ minecraft:green_glazed_terracotta[facing=west] run return 0
setblock ~ ~-1 ~ minecraft:white_wool
scoreboard players remove #arena mirror_poison_count 1
