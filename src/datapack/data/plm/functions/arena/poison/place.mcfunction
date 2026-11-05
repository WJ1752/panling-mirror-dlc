setblock ~ ~-1 ~ minecraft:green_glazed_terracotta[facing=west]
tp @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] ~ ~ ~
data modify storage plm:arena frontier append from entity @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] Pos
scoreboard players add #arena mirror_poison_count 1
