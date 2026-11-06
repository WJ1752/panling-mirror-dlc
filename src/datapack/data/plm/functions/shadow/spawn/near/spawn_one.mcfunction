# 一只不怕日光的影域野怪，位置由玩家附近的安全地表候选点确定。
execute unless score #pack shadow_tmp matches 1 if entity @e[tag=plm_shadow_wild,distance=..24] run return 0
execute if score @s shadow_spawn_dir matches 1 run summon minecraft:husk ~ ~ ~ {Tags:["panling","monster","plm_shadow_wild"],CustomName:'{"text":"霜蚀遗骸","color":"gray"}',CustomNameVisible:1b,PersistenceRequired:1b,CanPickUpLoot:0b,DeathLootTable:"minecraft:empty",Attributes:[{Name:"generic.max_health",Base:26d},{Name:"generic.movement_speed",Base:0.25d},{Name:"generic.attack_damage",Base:4d}],Health:26f}
execute if score @s shadow_spawn_dir matches 2 run summon minecraft:spider ~ ~ ~ {Tags:["panling","monster","plm_shadow_wild"],CustomName:'{"text":"镜穴蛛","color":"dark_gray"}',CustomNameVisible:1b,PersistenceRequired:1b,CanPickUpLoot:0b,DeathLootTable:"minecraft:empty"}
execute if score @s shadow_spawn_dir matches 3.. run summon minecraft:pillager ~ ~ ~ {Tags:["panling","monster","plm_shadow_wild"],CustomName:'{"text":"裂隙弩卫","color":"gray"}',CustomNameVisible:1b,PersistenceRequired:1b,CanPickUpLoot:0b,DeathLootTable:"minecraft:empty",HandItems:[{id:"minecraft:crossbow",Count:1b},{}],HandDropChances:[0f,0f]}
scoreboard players add #shadow shadow_mob_count 1
scoreboard players set #found shadow_tmp 1
