scoreboard players set #tomb ds_lamps 0
scoreboard players add #tomb ds_clock 1
execute if score #tomb ds_cd matches 1.. run scoreboard players remove #tomb ds_cd 1
execute if score #tomb ds_stage matches 1 as @e[type=interaction,tag=ds_tomb_box1,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/box1
execute if score #tomb ds_stage matches 1 as @e[type=interaction,tag=ds_tomb_lamp1_0,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp1_0
execute if score #tomb ds_stage matches 1 as @e[type=interaction,tag=ds_tomb_lamp1_1,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp1_1
execute if score #tomb ds_stage matches 1 as @e[type=interaction,tag=ds_tomb_lamp1_2,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp1_2
execute if score #tomb ds_stage matches 1 if score #tomb ds_count matches 3.. run function plm:domains/tomb/stage/2
execute if score #tomb ds_stage matches 2 as @e[type=interaction,tag=ds_tomb_box2,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/box2
execute if score #tomb ds_stage matches 2 as @e[type=interaction,tag=ds_tomb_lamp2_0,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp2_0
execute if score #tomb ds_stage matches 2 as @e[type=interaction,tag=ds_tomb_lamp2_1,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp2_1
execute if score #tomb ds_stage matches 2 as @e[type=interaction,tag=ds_tomb_lamp2_2,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp2_2
execute if score #tomb ds_stage matches 2 as @e[type=interaction,tag=ds_tomb_false_face,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/false_face
execute if score #tomb ds_stage matches 2 if score #tomb ds_count matches 3.. run function plm:domains/tomb/stage/3
execute if score #tomb ds_stage matches 3 as @e[type=interaction,tag=ds_tomb_box3,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/box3
execute if score #tomb ds_stage matches 3 as @e[type=interaction,tag=ds_tomb_lamp3_0,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp3_0
execute if score #tomb ds_stage matches 3 as @e[type=interaction,tag=ds_tomb_lamp3_1,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp3_1
execute if score #tomb ds_stage matches 3 as @e[type=interaction,tag=ds_tomb_lamp3_2,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp3_2
execute if score #tomb ds_stage matches 3 as @e[type=interaction,tag=ds_tomb_lamp3_3,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/lamp3_3
execute if score #tomb ds_stage matches 3 if score #tomb ds_count matches 4.. run function plm:domains/tomb/stage/4
execute if score #tomb ds_stage matches 4.. unless entity @e[type=husk,tag=dm_boss_tomb,limit=1] run function plm:domains/tomb/abort
execute unless score #tomb dm_state matches 2 run return 0
execute if score #tomb ds_stage matches 4 as @e[type=interaction,tag=ds_tomb_flame0,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/flame0
execute if score #tomb ds_stage matches 4 positioned ~73 ~1 ~10 if block ~ ~ ~ lantern run scoreboard players add #tomb ds_lamps 1
execute if score #tomb ds_stage matches 4 if score #tomb ds_seq matches 0..1 positioned ~73 ~1 ~10 if block ~ ~ ~ lantern if entity @e[tag=dm_boss_tomb,distance=..8] run scoreboard players set #tomb ds_window 3
execute if score #tomb ds_stage matches 4 as @e[type=interaction,tag=ds_tomb_flame1,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/flame1
execute if score #tomb ds_stage matches 4 positioned ~85 ~1 ~10 if block ~ ~ ~ lantern run scoreboard players add #tomb ds_lamps 1
execute if score #tomb ds_stage matches 4 if score #tomb ds_seq matches 0..1 positioned ~85 ~1 ~10 if block ~ ~ ~ lantern if entity @e[tag=dm_boss_tomb,distance=..8] run scoreboard players set #tomb ds_window 3
execute if score #tomb ds_stage matches 4 as @e[type=interaction,tag=ds_tomb_flame2,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/flame2
execute if score #tomb ds_stage matches 4 positioned ~85 ~1 ~21 if block ~ ~ ~ lantern run scoreboard players add #tomb ds_lamps 1
execute if score #tomb ds_stage matches 4 if score #tomb ds_seq matches 0..1 positioned ~85 ~1 ~21 if block ~ ~ ~ lantern if entity @e[tag=dm_boss_tomb,distance=..8] run scoreboard players set #tomb ds_window 3
execute if score #tomb ds_stage matches 4 as @e[type=interaction,tag=ds_tomb_flame3,limit=1] at @s if data entity @s interaction run function plm:domains/tomb/prop/flame3
execute if score #tomb ds_stage matches 4 positioned ~73 ~1 ~21 if block ~ ~ ~ lantern run scoreboard players add #tomb ds_lamps 1
execute if score #tomb ds_stage matches 4 if score #tomb ds_seq matches 0..1 positioned ~73 ~1 ~21 if block ~ ~ ~ lantern if entity @e[tag=dm_boss_tomb,distance=..8] run scoreboard players set #tomb ds_window 3
execute if score #tomb ds_stage matches 4 run function plm:domains/tomb/watch
execute as @e[tag=ds_wind_tomb] at @s run function plm:domains/tomb/wind
execute if score #tomb ds_stage matches 4.. if score #tomb ds_hp matches ..0 run function plm:domains/tomb/win
execute unless score #tomb dm_state matches 2 run return 0
execute if score #tomb ds_stage matches 4.. as @e[type=husk,tag=dm_boss_tomb,limit=1] run function plm:domains/tomb/shield
execute if score #tomb ds_window matches 1.. run scoreboard players remove #tomb ds_window 1
execute if score #tomb ds_stage matches 4.. if score #tomb ds_clock matches 40.. run title @a[tag=plm_d_tomb] actionbar [{"text":"无面守陵人　"},{"score":{"name":"#tomb","objective":"ds_hp"}}]
execute if score #tomb ds_clock matches 40.. run scoreboard players set #tomb ds_clock 0
