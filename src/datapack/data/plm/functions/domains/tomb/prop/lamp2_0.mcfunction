scoreboard players set #valid ds_count 0
execute on target if entity @s[tag=plm_d_tomb] run scoreboard players set #valid ds_count 1
execute unless score #valid ds_count matches 1 run data remove entity @s interaction
execute unless score #valid ds_count matches 1 run return 0
scoreboard players set #wick ds_count 0
execute on target if score @s ds_wick matches 1.. run scoreboard players set #wick ds_count 1
execute unless score #wick ds_count matches 1 on target run tellraw @s {"text":"先从烛匣取烛。"}
execute unless score #wick ds_count matches 1 run data remove entity @s interaction
execute unless score #wick ds_count matches 1 run return 0
execute on target run scoreboard players remove @s ds_wick 1
setblock ~ ~-1 ~ lantern
particle soul ~ ~ ~ 0.4 0.4 0.4 0.02 10
scoreboard players add #tomb ds_count 1
kill @s
