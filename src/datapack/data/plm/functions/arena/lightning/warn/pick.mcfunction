# 对齐目标脚下的 X/Z，再将 Y 投影到同维度锚点所在地面。
summon minecraft:marker ~ ~ ~ {Tags:["mirror_lightning","mirror_arena_hazard"]}
data modify entity @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] Pos[1] set from entity @e[type=minecraft:marker,tag=mirror_arena_anchor,distance=..70,limit=1] Pos[1]
scoreboard players set #arena mirror_lightning_warn 30
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run particle minecraft:end_rod ~0.5 ~0.2 ~0.5 1.2 0.1 1.2 0.02 40
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run playsound minecraft:entity.lightning_bolt.impact master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 0.6 1.6
title @a[tag=mirror_arena_inside,distance=0..] actionbar {"text":"⚡ 雷击预警 1.5s","color":"yellow"}
