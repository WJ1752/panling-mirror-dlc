# <=300（50%）：永久变镜中倒影；清旧召唤；颜色规则结束；2s 无敌
scoreboard players set #arena mirror_boss_phase 3
scoreboard players set #arena mirror_invuln 40
scoreboard players set #arena mirror_color_rules 0
scoreboard players set #arena mirror_lord_timer 0
scoreboard players set #arena mirror_skill_timer 0
scoreboard players set #arena mirror_summon_timer 8
scoreboard players set #arena mirror_weapon_timer 10
function plm:arena/summon/clear
function plm:arena/panel/dim
function plm:arena/boss/name/reflection
function plm:arena/boss/appearance/reflection
function plm:arena/boss/weapon/random
bossbar set plm:mirror_boss name {"text":"镜中倒影","color":"light_purple"}
bossbar set plm:mirror_boss color purple
title @a[tag=mirror_arena_inside,distance=0..] title {"text":"镜中倒影","color":"light_purple","bold":true}
title @a[tag=mirror_arena_inside,distance=0..] subtitle {"text":"血量 50% · 颜色规则结束 · 2s 无敌","color":"gray"}
execute at @e[tag=mirror_arena_boss,limit=1] run particle minecraft:reverse_portal ~ ~1 ~ 1 1.5 1 0.2 120
execute at @e[tag=mirror_arena_boss,limit=1] run playsound minecraft:entity.wither.spawn master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 0.8
