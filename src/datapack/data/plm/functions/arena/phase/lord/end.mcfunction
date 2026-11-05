# 占位技能：4 格范围 6 点伤害；然后变回影主，保留武器，恢复召唤，CD 10s
execute at @e[tag=mirror_arena_boss,limit=1] as @a[tag=mirror_arena_inside,distance=..4] run damage @s 6 minecraft:magic
execute at @e[tag=mirror_arena_boss,limit=1] run particle minecraft:explosion_emitter ~ ~1 ~ 0 0 0 0 1
execute at @e[tag=mirror_arena_boss,limit=1] run playsound minecraft:entity.generic.explode master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 1
scoreboard players set #arena mirror_boss_phase 1
scoreboard players set #arena mirror_lord_cd 10
scoreboard players set #arena mirror_lord_timer 0
scoreboard players set #arena mirror_skill_timer 0
scoreboard players set #arena mirror_summon_timer 8
function plm:arena/boss/name/shadow
function plm:arena/boss/appearance/shadow
bossbar set plm:mirror_boss name {"text":"影主","color":"white"}
bossbar set plm:mirror_boss color white
title @a[tag=mirror_arena_inside,distance=0..] actionbar {"text":"镜主收回武器 · 影主恢复召唤（CD 10s）","color":"gray"}
