scoreboard players set #valid ds_count 0
execute on attacker if entity @s[tag=plm_d_fire] run scoreboard players set #valid ds_count 1
execute unless score #valid ds_count matches 1 run data remove entity @s attack
execute unless score #valid ds_count matches 1 run return 0
setblock ~ ~-1 ~ air
particle flame ~ ~ ~ 1.4 0.2 1.4 0.04 32
scoreboard players add #fire ds_count 1
summon marker ~ ~ ~ {Tags:["dm_scene_fire","ds_fire_ember"]}
kill @s
