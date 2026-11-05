scoreboard players operation @s dm_run = #fire dm_run
scoreboard players operation @s dm_depth = #fire dm_depth
execute store result score @s dm_party if entity @a[tag=plm_d_fire]
scoreboard players set #fire dm_state 2
execute unless entity @a[tag=plm_d_fire] run function plm:domains/fire/abort
execute unless score #fire dm_state matches 2 run return 0
execute as @a[tag=plm_d_fire,gamemode=survival] run tag @s add plm_was_survival
gamemode adventure @a[tag=plm_d_fire,gamemode=survival]
scoreboard players set @a[tag=plm_d_fire] dm_died 0
scoreboard players set @a[tag=plm_d_fire] dm_dead 0
scoreboard players set @s dm_age 0
scoreboard players set #fire dm_deaths 0
scoreboard players set @a[tag=plm_d_fire] dm_leave 0
execute as @a[tag=plm_d_fire] run scoreboard players operation @s dm_leave = @s mirror_leave
function plm:domains/fire/setup
function plm:domains/fire/retreat_gate
tp @a[tag=plm_d_fire] ~3.5 ~1 ~15.5 -90 0
