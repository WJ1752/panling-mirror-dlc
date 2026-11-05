kill @e[tag=ds_prop_valley]
scoreboard players set #valley ds_stage 4
scoreboard players set #valley ds_count 0
tellraw @a[tag=plm_d_valley] {"text": "攻击池中发光的倒影。池干则跟随水声转移；末段开主闸。", "color": "gold"}
summon husk ~69.5 ~1 ~6.5 {Tags:["dm_scene_valley","dm_boss_valley","dm_boss","monster"],Health:1024f,Attributes:[{Name:"generic.max_health",Base:1024d},{Name:"generic.knockback_resistance",Base:1d}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{"text": "泪神倒影", "color": "gold"}',ArmorItems:[{},{},{},{id:"minecraft:turtle_helmet",Count:1b}]}
scoreboard players set #valley ds_window 36000
scoreboard players set #valley ds_seq 0
scoreboard players set #valley ds_hold 0
setblock ~79 ~1 ~17 dark_prismarine
setblock ~79 ~2 ~17 skeleton_skull
setblock ~80 ~1 ~18 waxed_copper_block
summon interaction ~80.5 ~2 ~18.5 {Tags:["dm_scene_valley","ds_prop_valley","ds_valley_main"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "主闸 · 全池放水", "color": "gold"}'}
