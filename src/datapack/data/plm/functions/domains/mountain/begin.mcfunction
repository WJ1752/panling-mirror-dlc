scoreboard players operation @s dm_run = #mountain dm_run
scoreboard players operation @s dm_depth = #mountain dm_depth
execute store result score @s dm_party if entity @a[tag=plm_d_mountain]
scoreboard players set #mountain dm_state 2
execute unless entity @a[tag=plm_d_mountain] run function plm:domains/mountain/abort
execute unless score #mountain dm_state matches 2 run return 0
execute as @a[tag=plm_d_mountain,gamemode=survival] run tag @s add plm_was_survival
gamemode adventure @a[tag=plm_d_mountain,gamemode=survival]
scoreboard players set @a[tag=plm_d_mountain] dm_died 0
scoreboard players set @a[tag=plm_d_mountain] dm_dead 0
scoreboard players set @s dm_age 0
scoreboard players set #mountain dm_deaths 0
scoreboard players set @a[tag=plm_d_mountain] dm_leave 0
execute as @a[tag=plm_d_mountain] run scoreboard players operation @s dm_leave = @s mirror_leave
function plm:domains/mountain/setup
function plm:domains/mountain/retreat_gate
tp @a[tag=plm_d_mountain] ~3.5 ~1 ~15.5 -90 0
