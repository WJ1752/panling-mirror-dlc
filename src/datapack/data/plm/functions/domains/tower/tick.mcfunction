scoreboard players add #tower ds_clock 1
execute if score #tower ds_cd matches 1.. run scoreboard players remove #tower ds_cd 1
execute if score #tower ds_stage matches 1 unless entity @e[tag=ds_guard_tower] positioned ~28 ~5 ~10 if entity @a[tag=plm_d_tower,dx=5,dy=5,dz=10] at @s run function plm:domains/tower/stage/2
execute if score #tower ds_stage matches 2 positioned ~60 ~11 ~10 if entity @a[tag=plm_d_tower,dx=4,dy=4,dz=10] at @s run function plm:domains/tower/stage/3
execute positioned ~10 ~2 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~15 ~3 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~15 ~3 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~20 ~4 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~20 ~4 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~25 ~5 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~25 ~5 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~30 ~6 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~30 ~6 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~35 ~7 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~35 ~7 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~40 ~8 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~40 ~8 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~45 ~9 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~45 ~9 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~50 ~10 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~50 ~10 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~55 ~11 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~55 ~11 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~60 ~12 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute positioned ~60 ~12 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] if block ~-4 ~-1 ~3 deepslate_tiles run particle falling_dust gravel ~-3 ~ ~5 1 0.2 1 0 4
execute positioned ~65 ~13 ~9 if entity @a[tag=plm_d_tower,dx=3,dy=4,dz=12] run fill ~-10 ~-2 ~1 ~-6 ~-2 ~9 air
execute if score #tower ds_stage matches 3.. unless entity @e[type=husk,tag=dm_boss_tower,limit=1] run function plm:domains/tower/abort
execute unless score #tower dm_state matches 2 run return 0
execute if score #tower ds_stage matches 3 run function plm:domains/tower/boss_tick
execute if score #tower ds_stage matches 3.. if score #tower ds_hp matches ..0 run function plm:domains/tower/win
execute unless score #tower dm_state matches 2 run return 0
execute if score #tower ds_stage matches 3.. as @e[type=husk,tag=dm_boss_tower,limit=1] run function plm:domains/tower/shield
execute if score #tower ds_window matches 1.. run scoreboard players remove #tower ds_window 1
execute if score #tower ds_stage matches 3.. if score #tower ds_clock matches 40.. run title @a[tag=plm_d_tower] actionbar [{"text":"塔影镇　"},{"score":{"name":"#tower","objective":"ds_hp"}}]
execute if score #tower ds_clock matches 40.. run scoreboard players set #tower ds_clock 0
