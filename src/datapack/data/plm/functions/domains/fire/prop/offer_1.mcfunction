scoreboard players set #valid ds_count 0
execute on attacker if entity @s[tag=plm_d_fire] run scoreboard players set #valid ds_count 1
execute unless score #valid ds_count matches 1 run data remove entity @s attack
execute unless score #valid ds_count matches 1 run return 0
setblock ~ ~-1 ~ air
particle soul_fire_flame ~ ~ ~ 1 1 1 0.04 35
scoreboard players set #fire ds_window 100
scoreboard players set #fire ds_hold 120
execute if score #fire ds_phase matches 3 unless score #fire ds_seq matches 2 run scoreboard players set #fire ds_window 0
execute if score #fire ds_phase matches 3 unless score #fire ds_seq matches 2 run scoreboard players set #fire ds_hold 20
scoreboard players operation #ratio ds_hp = #fire ds_hp
scoreboard players operation #ratio ds_hp *= #100 ds_hp
scoreboard players operation #ratio ds_hp /= #fire ds_max
execute if score #ratio ds_hp matches 36..70 run scoreboard players set #fire ds_hold 400
summon marker ~ ~ ~ {Tags:["dm_scene_fire","ds_fire_ember"]}
scoreboard players set #fire ds_seq 2
execute as @e[tag=dm_boss_fire,limit=1] at @s facing entity @p[tag=plm_d_fire] eyes run tp @s ~ ~ ~ ~ ~
execute if score #fire ds_window matches 1.. run tellraw @a[tag=plm_d_fire] {"text":"双心暴露！五秒内攻击炎魔。","color":"red"}
kill @s
