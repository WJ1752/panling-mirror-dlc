advancement revoke @s only plm:domains/hit_tower
scoreboard players set #hit ds_hp 2048
execute store result score #left ds_hp run data get entity @e[type=husk,tag=dm_boss_tower,limit=1] AbsorptionAmount 1
scoreboard players operation #hit ds_hp -= #left ds_hp
data modify entity @e[type=husk,tag=dm_boss_tower,limit=1] AbsorptionAmount set value 2048f
execute unless entity @s[tag=plm_d_tower] run return 0
execute unless score #tower ds_window matches 1.. run return 0
execute if score #hit ds_hp matches ..0 run function plm:domains/weapon_hit
scoreboard players operation #hit ds_hp *= #scale ds_hp
execute if score #hit ds_hp matches 401.. run scoreboard players set #hit ds_hp 400
scoreboard players operation #tower ds_hp -= #hit ds_hp
