kill @e[tag=ds_prop_mountain]
scoreboard players set #mountain ds_stage 4
scoreboard players set #mountain ds_count 0
tellraw @a[tag=plm_d_mountain] {"text": "四兽附身 · 踩亮坛后击打显形的映主。错坛回血；最后依次剥去四形。", "color": "gold"}
summon husk ~82.5 ~1 ~15.5 {Tags:["dm_scene_mountain","dm_boss_mountain","dm_boss","monster"],Health:1024f,Attributes:[{Name:"generic.max_health",Base:1024d},{Name:"generic.knockback_resistance",Base:1d}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{"text": "四圣兽映主", "color": "gold"}',ArmorItems:[{},{},{},{id:"minecraft:dragon_head",Count:1b}]}
scoreboard players set #mountain ds_hold 0
scoreboard players set #cycle ds_clock 300
scoreboard players set #render ds_seq -1
