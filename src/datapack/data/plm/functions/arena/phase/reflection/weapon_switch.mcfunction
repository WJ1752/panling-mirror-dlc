# 6 把 DLC 武器只做手持占位；不做技能逻辑
scoreboard players set #arena mirror_weapon_timer 10
scoreboard players set #arena mirror_skill_timer 10
function plm:arena/boss/weapon/random
execute at @e[tag=mirror_arena_boss,limit=1] run particle minecraft:end_rod ~ ~1.5 ~ 0.4 0.6 0.4 0.1 10
execute at @e[tag=mirror_arena_boss,limit=1] run playsound minecraft:item.trident.throw master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 0.6 1.4
title @a[tag=mirror_arena_inside,distance=0..] actionbar [{"text":"镜中倒影换武器 · ","color":"gray"},{"score":{"name":"#boss","objective":"mirror_weapon"}}]
