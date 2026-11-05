execute unless score #tower dm_state matches 2 run return 0
scoreboard players set #tower dm_state 3
scoreboard players operation #settle dm_age = @s dm_age
scoreboard players operation #settle dm_depth = @s dm_depth
scoreboard players operation #settle dm_deaths = #tower dm_deaths
execute store result score #online dm_party if entity @a[tag=plm_d_tower]
execute if score #online dm_party < #tower dm_party run function plm:domains/tower/save_receipt
execute as @a[tag=plm_d_tower] unless score @s dm_paid = @s dm_run run function plm:domains/tower/reward
function plm:domains/tower/release
