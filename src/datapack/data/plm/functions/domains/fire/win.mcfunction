execute unless score #fire dm_state matches 2 run return 0
scoreboard players set #fire dm_state 3
scoreboard players operation #settle dm_age = @s dm_age
scoreboard players operation #settle dm_depth = @s dm_depth
scoreboard players operation #settle dm_deaths = #fire dm_deaths
execute store result score #online dm_party if entity @a[tag=plm_d_fire]
execute if score #online dm_party < #fire dm_party run function plm:domains/fire/save_receipt
execute as @a[tag=plm_d_fire] unless score @s dm_paid = @s dm_run run function plm:domains/fire/reward
function plm:domains/fire/release
