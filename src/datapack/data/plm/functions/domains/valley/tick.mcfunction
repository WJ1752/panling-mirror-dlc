scoreboard players add #valley ds_clock 1
execute if score #valley ds_cd matches 1.. run scoreboard players remove #valley ds_cd 1
execute if score #valley ds_stage matches 1 as @e[type=interaction,tag=ds_valley_first,limit=1] at @s if data entity @s interaction run function plm:domains/valley/prop/first
execute if score #valley ds_stage matches 1 if score #valley ds_count matches 1.. run function plm:domains/valley/stage/2
execute if score #valley ds_stage matches 2 as @e[type=interaction,tag=ds_valley_altar,limit=1] at @s if data entity @s interaction run function plm:domains/valley/prop/altar
execute as @e[tag=ds_practice_valley,limit=1] on attacker if entity @s[tag=plm_d_valley] at @e[tag=plm_origin_valley,limit=1] run function plm:domains/valley/fade
execute if score #valley ds_stage matches 2 if score #valley ds_count matches 3.. run function plm:domains/valley/stage/3
execute if score #valley ds_stage matches 3 as @e[type=interaction,tag=ds_valley_pool0,limit=1] at @s if data entity @s interaction run function plm:domains/valley/prop/pool0
execute if score #valley ds_stage matches 3 as @e[type=interaction,tag=ds_valley_pool1,limit=1] at @s if data entity @s interaction run function plm:domains/valley/prop/pool1
execute if score #valley ds_stage matches 3 as @e[type=interaction,tag=ds_valley_pool2,limit=1] at @s if data entity @s interaction run function plm:domains/valley/prop/pool2
execute if score #valley ds_stage matches 3 if score #valley ds_count matches 3.. run function plm:domains/valley/stage/4
execute if score #valley ds_stage matches 4.. unless entity @e[type=husk,tag=dm_boss_valley,limit=1] run function plm:domains/valley/abort
execute unless score #valley dm_state matches 2 run return 0
execute if score #valley ds_stage matches 4 as @e[type=interaction,tag=ds_valley_main,limit=1] at @s if data entity @s interaction run function plm:domains/valley/prop/main
execute if score #valley ds_stage matches 4 run function plm:domains/valley/boss_tick
execute if score #valley ds_stage matches 4.. if score #valley ds_hp matches ..0 run function plm:domains/valley/win
execute unless score #valley dm_state matches 2 run return 0
execute if score #valley ds_stage matches 4.. as @e[type=husk,tag=dm_boss_valley,limit=1] run function plm:domains/valley/shield
execute if score #valley ds_window matches 1.. run scoreboard players remove #valley ds_window 1
execute if score #valley ds_stage matches 4.. if score #valley ds_clock matches 40.. run title @a[tag=plm_d_valley] actionbar [{"text":"泪神倒影　"},{"score":{"name":"#valley","objective":"ds_hp"}}]
execute if score #valley ds_clock matches 40.. run scoreboard players set #valley ds_clock 0
