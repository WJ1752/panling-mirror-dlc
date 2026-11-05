execute unless score #tomb dm_state matches 2 run return 0
scoreboard players set #tomb dm_state 3
scoreboard players operation #settle dm_age = @s dm_age
scoreboard players operation #settle dm_depth = @s dm_depth
scoreboard players operation #settle dm_deaths = #tomb dm_deaths
execute store result score #online dm_party if entity @a[tag=plm_d_tomb]
execute if score #online dm_party < #tomb dm_party run function plm:domains/tomb/save_receipt
execute as @a[tag=plm_d_tomb] unless score @s dm_paid = @s dm_run run function plm:domains/tomb/reward
function plm:domains/tomb/release
