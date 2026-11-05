# 粒子与音效模拟落雷，避免原版雷电额外伤害旁观者或引燃场边。
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run particle minecraft:electric_spark ~0.5 ~2 ~0.5 0.25 2.0 0.25 0.1 90
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] positioned ~0.5 ~ ~0.5 as @a[tag=mirror_arena_inside,distance=..4] run damage @s 6 minecraft:lightning_bolt
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run function plm:arena/poison/clear3
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run playsound minecraft:entity.lightning_bolt.thunder master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 1
kill @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1]
