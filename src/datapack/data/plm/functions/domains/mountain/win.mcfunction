execute unless score #mountain dm_state matches 2 run return 0
scoreboard players set #mountain dm_state 3
scoreboard players operation #settle dm_age = @s dm_age
scoreboard players operation #settle dm_depth = @s dm_depth
scoreboard players operation #settle dm_deaths = #mountain dm_deaths
execute store result score #online dm_party if entity @a[tag=plm_d_mountain]
execute if score #online dm_party < #mountain dm_party run function plm:domains/mountain/save_receipt
execute as @a[tag=plm_d_mountain] unless score @s dm_paid = @s dm_run run function plm:domains/mountain/reward
function plm:domains/mountain/release
