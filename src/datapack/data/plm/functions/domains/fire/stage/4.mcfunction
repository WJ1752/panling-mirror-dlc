kill @e[tag=ds_prop_fire]
scoreboard players set #fire ds_stage 4
scoreboard players set #fire ds_count 0
tellraw @a[tag=plm_d_fire] {"text": "双心炎魔 · 击碎供品后追击发光的双心。", "color": "gold"}
summon husk ~82.5 ~1 ~15.5 {Tags:["dm_scene_fire","dm_boss_fire","dm_boss","monster"],Health:1024f,Attributes:[{Name:"generic.max_health",Base:1024d},{Name:"generic.knockback_resistance",Base:1d}],DeathLootTable:"minecraft:empty",ArmorDropChances:[0f,0f,0f,0f],NoAI:1b,Silent:1b,PersistenceRequired:1b,Invulnerable:1b,AbsorptionAmount:2048f,CustomNameVisible:1b,CustomName:'{"text": "双心炎魔", "color": "gold"}',ArmorItems:[{},{},{},{id:"minecraft:golden_helmet",Count:1b}]}
scoreboard players set #fire ds_phase 1
scoreboard players set #fire ds_seq 0
function plm:domains/fire/offer0
