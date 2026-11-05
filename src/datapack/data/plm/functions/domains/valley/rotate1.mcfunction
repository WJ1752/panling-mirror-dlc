kill @e[tag=dm_boss_valley]
fill ~79 ~ ~4 ~84 ~ ~9 air
fill ~84 ~ ~20 ~89 ~ ~25 water
summon husk ~86.5 ~1 ~22.5 {Tags:["dm_scene_valley","dm_boss_valley","dm_boss","monster"],Health:1024f,Attributes:[{Name:"generic.max_health",Base:1024d},{Name:"generic.knockback_resistance",Base:1d}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{"text": "泪神倒影", "color": "gold"}',ArmorItems:[{},{},{},{id:"minecraft:turtle_helmet",Count:1b}]}
scoreboard players set #valley ds_seq 2
scoreboard players set #valley ds_cd 300
