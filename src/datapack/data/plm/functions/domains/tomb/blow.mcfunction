execute at @e[tag=ds_prop_tomb,sort=random,limit=2] run summon husk ~ ~ ~ {Tags:["dm_scene_tomb","ds_wind_tomb","monster"],NoGravity:1b,DeathLootTable:"minecraft:empty",Silent:1b,NoAI:1b,Health:6f,PersistenceRequired:1b,CustomNameVisible:1b,CustomName:'{"text":"吹灯影 · 击退"}'}
scoreboard players set #tomb ds_cd 120
