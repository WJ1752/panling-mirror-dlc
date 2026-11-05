scoreboard players add #mountain ds_clock 1
execute if score #mountain ds_cd matches 1.. run scoreboard players remove #mountain ds_cd 1
execute if score #mountain ds_stage matches 1 if score #mountain ds_count matches 1.. run function plm:domains/mountain/stage/2
execute if score #mountain ds_stage matches 2 if score #mountain ds_count matches 2.. run function plm:domains/mountain/stage/3
execute if score #mountain ds_stage matches 3 if score #mountain ds_count matches 4.. run function plm:domains/mountain/stage/4
execute if score #mountain ds_stage matches 4.. unless entity @e[type=husk,tag=dm_boss_mountain,limit=1] run function plm:domains/mountain/abort
execute unless score #mountain dm_state matches 2 run return 0
scoreboard players operation #before ds_stage = #mountain ds_stage
scoreboard players operation #need ds_seq = #mountain ds_count
execute if score #mountain ds_stage matches 2 run scoreboard players add #need ds_seq 2
execute if score #mountain ds_stage matches 4 if score #mountain ds_hold matches ..1 run scoreboard players operation #need ds_seq = #mountain ds_seq
scoreboard players operation #need ds_seq %= #four ds_seq
tag @a[tag=plm_d_mountain] remove ds_on_altar
scoreboard players set #stepped ds_count 0
execute if score #before ds_stage matches 1 positioned ~24 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 1 positioned ~24 ~1 ~14 if score #need ds_seq matches 0 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 1 positioned ~24 ~1 ~14 if score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 1 positioned ~24 ~1 ~14 unless score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 1 positioned ~6 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 1 positioned ~6 ~1 ~14 if score #need ds_seq matches 2 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 1 positioned ~6 ~1 ~14 if score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 1 positioned ~6 ~1 ~14 unless score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~23 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~23 if score #need ds_seq matches 1 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~23 if score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~23 unless score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~5 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~5 if score #need ds_seq matches 3 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~5 if score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 1 positioned ~15 ~1 ~5 unless score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 2 positioned ~56 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 2 positioned ~56 ~1 ~14 if score #need ds_seq matches 0 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 2 positioned ~56 ~1 ~14 if score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 2 positioned ~56 ~1 ~14 unless score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 2 positioned ~38 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 2 positioned ~38 ~1 ~14 if score #need ds_seq matches 2 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 2 positioned ~38 ~1 ~14 if score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 2 positioned ~38 ~1 ~14 unless score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~23 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~23 if score #need ds_seq matches 1 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~23 if score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~23 unless score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~5 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~5 if score #need ds_seq matches 3 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~5 if score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 2 positioned ~47 ~1 ~5 unless score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 3 positioned ~88 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 3 positioned ~88 ~1 ~14 if score #need ds_seq matches 0 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 3 positioned ~88 ~1 ~14 if score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 3 positioned ~88 ~1 ~14 unless score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 3 positioned ~70 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 3 positioned ~70 ~1 ~14 if score #need ds_seq matches 2 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 3 positioned ~70 ~1 ~14 if score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 3 positioned ~70 ~1 ~14 unless score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~23 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~23 if score #need ds_seq matches 1 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~23 if score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~23 unless score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~5 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~5 if score #need ds_seq matches 3 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~5 if score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 3 positioned ~79 ~1 ~5 unless score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 4 positioned ~88 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 4 positioned ~88 ~1 ~14 if score #need ds_seq matches 0 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 4 positioned ~88 ~1 ~14 if score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 4 positioned ~88 ~1 ~14 unless score #need ds_seq matches 0 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 4 if score #need ds_seq matches 0 unless score #render ds_seq matches 0 run item replace entity @e[type=husk,tag=dm_boss_mountain,limit=1] armor.head with minecraft:dragon_head
execute if score #before ds_stage matches 4 positioned ~70 ~1 ~14 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 4 positioned ~70 ~1 ~14 if score #need ds_seq matches 2 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 4 positioned ~70 ~1 ~14 if score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 4 positioned ~70 ~1 ~14 unless score #need ds_seq matches 2 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 4 if score #need ds_seq matches 2 unless score #render ds_seq matches 2 run item replace entity @e[type=husk,tag=dm_boss_mountain,limit=1] armor.head with minecraft:skeleton_skull
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~23 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~23 if score #need ds_seq matches 1 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~23 if score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~23 unless score #need ds_seq matches 1 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 4 if score #need ds_seq matches 1 unless score #render ds_seq matches 1 run item replace entity @e[type=husk,tag=dm_boss_mountain,limit=1] armor.head with minecraft:red_banner
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~5 run tag @a[tag=plm_d_mountain,dx=2,dy=1,dz=2] add ds_on_altar
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~5 if score #need ds_seq matches 3 run particle end_rod ~1.5 ~1.8 ~1.5 0.20 0.8 0.20 0.02 3
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~5 if score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] run scoreboard players set #stepped ds_count 2
execute if score #before ds_stage matches 4 positioned ~79 ~1 ~5 unless score #need ds_seq matches 3 if entity @a[tag=plm_d_mountain,dx=2,dy=1,dz=2,tag=!ds_was_altar] unless score #stepped ds_count matches 2 run scoreboard players set #stepped ds_count 1
execute if score #before ds_stage matches 4 if score #need ds_seq matches 3 unless score #render ds_seq matches 3 run item replace entity @e[type=husk,tag=dm_boss_mountain,limit=1] armor.head with minecraft:turtle_helmet
scoreboard players operation #render ds_seq = #need ds_seq
tag @a[tag=plm_d_mountain,tag=!ds_on_altar] remove ds_was_altar
tag @a[tag=ds_on_altar,tag=plm_d_mountain] add ds_was_altar
execute if score #stepped ds_count matches 2 unless score #before ds_stage matches 4 run scoreboard players add #mountain ds_count 1
execute if score #before ds_stage matches 4 run function plm:domains/mountain/battle
execute if score #mountain ds_stage matches 4.. if score #mountain ds_hp matches ..0 run function plm:domains/mountain/win
execute unless score #mountain dm_state matches 2 run return 0
execute if score #mountain ds_stage matches 4.. as @e[type=husk,tag=dm_boss_mountain,limit=1] run function plm:domains/mountain/shield
execute if score #mountain ds_window matches 1.. run scoreboard players remove #mountain ds_window 1
execute if score #mountain ds_stage matches 4.. if score #mountain ds_clock matches 40.. run title @a[tag=plm_d_mountain] actionbar [{"text":"四圣兽映主　"},{"score":{"name":"#mountain","objective":"ds_hp"}}]
execute if score #mountain ds_clock matches 40.. run scoreboard players set #mountain ds_clock 0
