execute if predicate plm:shadow/spawn_position if block ~ ~-1 ~ #plm:shadow_spawn_floor if block ~ ~ ~ minecraft:air if block ~ ~1 ~ minecraft:air unless entity @a[tag=plm_shadow_safe,distance=..24] unless entity @e[type=marker,tag=plm_shadow_town_return,distance=..32] run function plm:shadow/spawn/near/spawn_one
execute if score #found shadow_tmp matches 1 run return 0
scoreboard players remove #search shadow_tmp 1
execute if score #search shadow_tmp matches 1.. positioned ~ ~-1 ~ run function plm:shadow/spawn/near/search
