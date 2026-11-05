data modify entity @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] Pos set from storage plm:arena frontier[0]
data remove storage plm:arena frontier[0]
execute at @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] if block ~ ~-1 ~ minecraft:green_glazed_terracotta[facing=west] run function plm:arena/poison/spread_one
scoreboard players remove #arena mirror_poison_need 1
execute if score #arena mirror_poison_need matches 1.. run function plm:arena/poison/spread_next
