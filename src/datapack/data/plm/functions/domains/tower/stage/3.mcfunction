kill @e[tag=ds_prop_tower]
scoreboard players set #tower ds_stage 3
scoreboard players set #tower ds_count 0
tellraw @a[tag=plm_d_tower] {"text": "塔顶环台 · 击败塔影。裂纹预告下一块崩塌位置。", "color": "gold"}
fill ~63 ~1 ~12 ~63 ~5 ~19 air
summon husk ~80.5 ~13 ~15.5 {Tags:["dm_scene_tower","dm_boss_tower","dm_boss","monster"],Health:1024f,Attributes:[{Name:"generic.max_health",Base:1024d},{Name:"generic.knockback_resistance",Base:1d}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{"text": "塔影镇", "color": "gold"}',ArmorItems:[{},{},{},{id:"minecraft:netherite_helmet",Count:1b}]}
scoreboard players set #tower ds_window 36000
scoreboard players set #tower ds_hold 0
scoreboard players set #tower ds_seq 0
