scoreboard players operation @s dm_run = #valley dm_run
scoreboard players operation @s dm_depth = #valley dm_depth
execute store result score @s dm_party if entity @a[tag=plm_d_valley]
scoreboard players set #valley dm_state 2
execute unless entity @a[tag=plm_d_valley] run function plm:domains/valley/abort
execute unless score #valley dm_state matches 2 run return 0
execute as @a[tag=plm_d_valley,gamemode=survival] run tag @s add plm_was_survival
gamemode adventure @a[tag=plm_d_valley,gamemode=survival]
scoreboard players set @a[tag=plm_d_valley] dm_died 0
scoreboard players set @a[tag=plm_d_valley] dm_dead 0
scoreboard players set @s dm_age 0
scoreboard players set #valley dm_deaths 0
scoreboard players set @a[tag=plm_d_valley] dm_leave 0
execute as @a[tag=plm_d_valley] run scoreboard players operation @s dm_leave = @s mirror_leave
function plm:domains/valley/setup
function plm:domains/valley/retreat_gate
tp @a[tag=plm_d_valley] ~3.5 ~1 ~15.5 -90 0
