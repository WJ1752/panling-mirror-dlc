execute in plm:domains if loaded 31 64 31 unless entity @e[tag=plm_hub] run function plm:domains/hub
execute as @a[tag=plm_hub_respawn,nbt=!{Health:0.0f}] in plm:domains run tp @s 16.5 64 16.5
tag @a[tag=plm_hub_respawn,nbt=!{Health:0.0f}] remove plm_hub_respawn
execute in minecraft:overworld positioned -309 11 801 if entity @a[distance=..24] unless entity @e[type=interaction,tag=plm_gate_map_fire,distance=..1] run function plm:domains/fire/place_gate
execute as @a[tag=plm_d_fire] unless score @s dm_run = #fire dm_run run function plm:domains/fire/recover
execute if score #fire dm_state matches 1 run scoreboard players remove #fire dm_time 1
execute if score #fire dm_state matches 1 if score #fire dm_time matches ..0 in plm:domains if loaded 256 64 0 if loaded 351 64 31 positioned 256.0 64 0.0 run function plm:domains/fire/start
execute if score #fire dm_state matches 2 in plm:domains positioned 256.0 64 0.0 if loaded ~ ~ ~ unless entity @e[type=marker,tag=plm_origin_fire,limit=1] run function plm:domains/fire/abort
execute if score #fire dm_state matches 2 in plm:domains as @e[type=marker,tag=plm_origin_fire,limit=1] at @s run function plm:domains/fire/step
execute in minecraft:overworld positioned 606 10 -130 if entity @a[distance=..24] unless entity @e[type=interaction,tag=plm_gate_map_tomb,distance=..1] run function plm:domains/tomb/place_gate
execute as @a[tag=plm_d_tomb] unless score @s dm_run = #tomb dm_run run function plm:domains/tomb/recover
execute if score #tomb dm_state matches 1 run scoreboard players remove #tomb dm_time 1
execute if score #tomb dm_state matches 1 if score #tomb dm_time matches ..0 in plm:domains if loaded 512 64 0 if loaded 607 64 31 positioned 512.0 64 0.0 run function plm:domains/tomb/start
execute if score #tomb dm_state matches 2 in plm:domains positioned 512.0 64 0.0 if loaded ~ ~ ~ unless entity @e[type=marker,tag=plm_origin_tomb,limit=1] run function plm:domains/tomb/abort
execute if score #tomb dm_state matches 2 in plm:domains as @e[type=marker,tag=plm_origin_tomb,limit=1] at @s run function plm:domains/tomb/step
execute in minecraft:overworld positioned -195 65 -180 if entity @a[distance=..24] unless entity @e[type=interaction,tag=plm_gate_map_tower,distance=..1] run function plm:domains/tower/place_gate
execute as @a[tag=plm_d_tower] unless score @s dm_run = #tower dm_run run function plm:domains/tower/recover
execute if score #tower dm_state matches 1 run scoreboard players remove #tower dm_time 1
execute if score #tower dm_state matches 1 if score #tower dm_time matches ..0 in plm:domains if loaded 768 64 0 if loaded 863 64 31 positioned 768.0 64 0.0 run function plm:domains/tower/start
execute if score #tower dm_state matches 2 in plm:domains positioned 768.0 64 0.0 if loaded ~ ~ ~ unless entity @e[type=marker,tag=plm_origin_tower,limit=1] run function plm:domains/tower/abort
execute if score #tower dm_state matches 2 in plm:domains as @e[type=marker,tag=plm_origin_tower,limit=1] at @s run function plm:domains/tower/step
execute in minecraft:overworld positioned -690 108 -637 if entity @a[distance=..24] unless entity @e[type=interaction,tag=plm_gate_map_valley,distance=..1] run function plm:domains/valley/place_gate
execute as @a[tag=plm_d_valley] unless score @s dm_run = #valley dm_run run function plm:domains/valley/recover
execute if score #valley dm_state matches 1 run scoreboard players remove #valley dm_time 1
execute if score #valley dm_state matches 1 if score #valley dm_time matches ..0 in plm:domains if loaded 1024 64 0 if loaded 1119 64 31 positioned 1024.0 64 0.0 run function plm:domains/valley/start
execute if score #valley dm_state matches 2 in plm:domains positioned 1024.0 64 0.0 if loaded ~ ~ ~ unless entity @e[type=marker,tag=plm_origin_valley,limit=1] run function plm:domains/valley/abort
execute if score #valley dm_state matches 2 in plm:domains as @e[type=marker,tag=plm_origin_valley,limit=1] at @s run function plm:domains/valley/step
execute in minecraft:overworld positioned -177 99 -831 if entity @a[distance=..24] unless entity @e[type=interaction,tag=plm_gate_map_mountain,distance=..1] run function plm:domains/mountain/place_gate
execute as @a[tag=plm_d_mountain] unless score @s dm_run = #mountain dm_run run function plm:domains/mountain/recover
execute if score #mountain dm_state matches 1 run scoreboard players remove #mountain dm_time 1
execute if score #mountain dm_state matches 1 if score #mountain dm_time matches ..0 in plm:domains if loaded 1280 64 0 if loaded 1375 64 31 positioned 1280.0 64 0.0 run function plm:domains/mountain/start
execute if score #mountain dm_state matches 2 in plm:domains positioned 1280.0 64 0.0 if loaded ~ ~ ~ unless entity @e[type=marker,tag=plm_origin_mountain,limit=1] run function plm:domains/mountain/abort
execute if score #mountain dm_state matches 2 in plm:domains as @e[type=marker,tag=plm_origin_mountain,limit=1] at @s run function plm:domains/mountain/step
