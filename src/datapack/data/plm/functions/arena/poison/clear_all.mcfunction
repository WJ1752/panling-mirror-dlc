# 只还原准入时已确认为空的专用毒格状态；保留面板、花纹和其它材质。
execute if data storage plm:arena frontier run fill ~-23 ~-1 ~-23 ~22 ~-1 ~22 minecraft:white_wool replace minecraft:green_glazed_terracotta[facing=west]
kill @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1]
data remove storage plm:arena frontier
scoreboard players set #arena mirror_poison_count 0
