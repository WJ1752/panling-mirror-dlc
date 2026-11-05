kill @e[tag=ds_prop_tomb]
scoreboard players set #tomb ds_stage 4
scoreboard players set #tomb ds_count 0
tellraw @a[tag=plm_d_tomb] {"text": "守陵人 · 领它走入灯圈。守卫会吹灯，右键补灯；残血须守四灯十秒。", "color": "gold"}
summon husk ~80.5 ~1 ~10.5 {Tags:["dm_scene_tomb","dm_boss_tomb","dm_boss","monster"],Health:1024f,Attributes:[{Name:"generic.max_health",Base:1024d},{Name:"generic.knockback_resistance",Base:1d}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{"text": "无面守陵人", "color": "gold"}',ArmorItems:[{},{},{},{id:"minecraft:carved_pumpkin",Count:1b}]}
setblock ~73 ~1 ~10 lantern
summon interaction ~73.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_flame0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "棺角灯 · 右键重燃", "color": "gold"}'}
setblock ~85 ~1 ~10 lantern
summon interaction ~85.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_flame1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "棺角灯 · 右键重燃", "color": "gold"}'}
setblock ~85 ~1 ~21 lantern
summon interaction ~85.5 ~2 ~21.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_flame2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "棺角灯 · 右键重燃", "color": "gold"}'}
setblock ~73 ~1 ~21 lantern
summon interaction ~73.5 ~2 ~21.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_flame3"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "棺角灯 · 右键重燃", "color": "gold"}'}
scoreboard players set #tomb ds_seq 0
scoreboard players set #tomb ds_hold 0
