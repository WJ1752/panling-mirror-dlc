scoreboard players set #valid ds_count 0
execute on target if entity @s[tag=plm_d_valley] run scoreboard players set #valid ds_count 1
execute unless score #valid ds_count matches 1 run data remove entity @s interaction
execute unless score #valid ds_count matches 1 run return 0
execute unless entity @e[tag=ds_practice_valley] at @e[tag=plm_origin_valley,limit=1] run function plm:domains/valley/reveal
data remove entity @s interaction
