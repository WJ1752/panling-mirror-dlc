execute unless score #valley dm_state matches 2 run return 0
scoreboard players set #valley dm_state 3
scoreboard players operation #settle dm_age = @s dm_age
scoreboard players operation #settle dm_depth = @s dm_depth
scoreboard players operation #settle dm_deaths = #valley dm_deaths
execute store result score #online dm_party if entity @a[tag=plm_d_valley]
execute if score #online dm_party < #valley dm_party run function plm:domains/valley/save_receipt
execute as @a[tag=plm_d_valley] unless score @s dm_paid = @s dm_run run function plm:domains/valley/reward
function plm:domains/valley/release
