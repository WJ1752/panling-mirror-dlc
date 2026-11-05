scoreboard players set #valid ds_count 0
execute on target if entity @s[tag=plm_d_valley] run scoreboard players set #valid ds_count 1
execute unless score #valid ds_count matches 1 run data remove entity @s interaction
execute unless score #valid ds_count matches 1 run return 0
execute unless score #valley ds_count matches 0 run data remove entity @s interaction
execute unless score #valley ds_count matches 0 run return 0
execute at @e[tag=plm_origin_valley,limit=1] run fill ~67 ~ ~4 ~72 ~ ~9 water
scoreboard players add #valley ds_count 1
kill @s
