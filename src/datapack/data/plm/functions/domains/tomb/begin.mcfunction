scoreboard players operation @s dm_run = #tomb dm_run
scoreboard players operation @s dm_depth = #tomb dm_depth
execute store result score @s dm_party if entity @a[tag=plm_d_tomb]
scoreboard players set #tomb dm_state 2
execute unless entity @a[tag=plm_d_tomb] run function plm:domains/tomb/abort
execute unless score #tomb dm_state matches 2 run return 0
execute as @a[tag=plm_d_tomb,gamemode=survival] run tag @s add plm_was_survival
gamemode adventure @a[tag=plm_d_tomb,gamemode=survival]
scoreboard players set @a[tag=plm_d_tomb] dm_died 0
scoreboard players set @a[tag=plm_d_tomb] dm_dead 0
scoreboard players set @s dm_age 0
scoreboard players set #tomb dm_deaths 0
scoreboard players set @a[tag=plm_d_tomb] dm_leave 0
execute as @a[tag=plm_d_tomb] run scoreboard players operation @s dm_leave = @s mirror_leave
function plm:domains/tomb/setup
function plm:domains/tomb/retreat_gate
tp @a[tag=plm_d_tomb] ~3.5 ~1 ~15.5 -90 0
