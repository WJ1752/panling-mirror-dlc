# 由 arena/start 在本局锚点处调用。不使用开发灰盒的绝对坐标或全服清场。
summon minecraft:husk ~0.5 ~ ~0.5 {Tags:["mirror_arena_boss","mirror_boss","monster"],NoAI:1b,Silent:1b,PersistenceRequired:1b,CanPickUpLoot:0b,DeathLootTable:"minecraft:empty",Health:1024.0f,AbsorptionAmount:2048.0f,ArmorDropChances:[0f,0f,0f,0f],HandDropChances:[0f,0f],Attributes:[{Name:"generic.max_health",Base:1024.0},{Name:"generic.knockback_resistance",Base:1.0},{Name:"generic.movement_speed",Base:0.0}]}
execute as @a[tag=mirror_arena_member] run function plm:arena/hit/abs_snapshot
scoreboard players set #fraction mirror_boss_damage 0
scoreboard players set #scale mirror_boss_damage 10000
scoreboard players set #native_scale mirror_boss_damage 1000
function plm:arena/boss/name/shadow
function plm:arena/boss/appearance/shadow
