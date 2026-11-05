scoreboard players operation @s dm_run = #tower dm_run
scoreboard players operation @s dm_depth = #tower dm_depth
execute store result score @s dm_party if entity @a[tag=plm_d_tower]
scoreboard players set #tower dm_state 2
execute unless entity @a[tag=plm_d_tower] run function plm:domains/tower/abort
execute unless score #tower dm_state matches 2 run return 0
execute as @a[tag=plm_d_tower,gamemode=survival] run tag @s add plm_was_survival
gamemode adventure @a[tag=plm_d_tower,gamemode=survival]
scoreboard players set @a[tag=plm_d_tower] dm_died 0
scoreboard players set @a[tag=plm_d_tower] dm_dead 0
scoreboard players set @s dm_age 0
scoreboard players set #tower dm_deaths 0
scoreboard players set @a[tag=plm_d_tower] dm_leave 0
execute as @a[tag=plm_d_tower] run scoreboard players operation @s dm_leave = @s mirror_leave
function plm:domains/tower/setup
function plm:domains/tower/retreat_gate
tp @a[tag=plm_d_tower] ~3.5 ~1 ~15.5 -90 0
