# 远程命中影主（CD 0）触发：瞬移 + 变镜主 + 抽武器
scoreboard players set #arena mirror_boss_phase 2
function plm:arena/boss/damage/window_reset
scoreboard players set #arena mirror_lord_timer 5
scoreboard players set #arena mirror_skill_timer 5
scoreboard players set #arena mirror_summon_timer 8
execute at @e[tag=mirror_tp,tag=mirror_arena_point,distance=..36,sort=random,limit=1] run tp @e[tag=mirror_arena_boss,limit=1] ~ ~ ~
function plm:arena/boss/name/lord
function plm:arena/boss/appearance/lord
function plm:arena/boss/weapon/random
bossbar set plm:mirror_boss name {"text":"镜主 · 蓄势 5s","color":"white"}
bossbar set plm:mirror_boss color white
execute at @e[tag=mirror_arena_boss,limit=1] run particle minecraft:portal ~ ~1 ~ 0.6 1.2 0.6 0.4 60
execute at @e[tag=mirror_arena_boss,limit=1] run playsound minecraft:entity.enderman.teleport master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 1
title @a[tag=mirror_arena_inside,distance=0..] title {"text":"镜主","color":"white","bold":true}
title @a[tag=mirror_arena_inside,distance=0..] subtitle {"text":"远程命中 · 5 秒蓄势（可打）","color":"gray"}
