scoreboard players set #valid ds_count 0
execute on target if entity @s[tag=plm_d_tomb] run scoreboard players set #valid ds_count 1
execute unless score #valid ds_count matches 1 run data remove entity @s interaction
execute unless score #valid ds_count matches 1 run return 0
execute on target run scoreboard players set @s ds_wick 4
execute on target run tellraw @s {"text":"已取四支长明烛。"}
data remove entity @s interaction
