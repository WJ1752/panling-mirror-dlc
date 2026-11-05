execute if block ~ ~ ~ minecraft:green_glazed_terracotta[facing=west] run scoreboard players set #arena mirror_tmp 1
scoreboard players add #arena mirror_poison_need 1
execute if score #arena mirror_tmp matches 0 if score #arena mirror_poison_need matches ..45 positioned ~1 ~ ~ run function plm:arena/poison/check_tile
