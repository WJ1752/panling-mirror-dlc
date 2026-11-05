# <=180（30%）：清场、停止召唤；闪电 + 毒地；继续换武器
scoreboard players set #arena mirror_boss_phase 4
scoreboard players set #arena mirror_color_rules 0
scoreboard players set #arena mirror_invuln 0
scoreboard players set #arena mirror_lightning_timer 0
scoreboard players set #arena mirror_lightning_warn 0
scoreboard players set #arena mirror_poison_timer 3
scoreboard players set #arena mirror_weapon_timer 10
scoreboard players set #arena mirror_skill_timer 10
scoreboard players set #arena mirror_summon_timer 0
function plm:arena/summon/clear
function plm:arena/panel/dim
function plm:arena/boss/name/reflection
function plm:arena/boss/appearance/reflection
function plm:arena/poison/init
bossbar set plm:mirror_boss name {"text":"镜中倒影 · 终局","color":"red"}
bossbar set plm:mirror_boss color red
title @a[tag=mirror_arena_inside,distance=0..] title {"text":"终局","color":"red","bold":true}
title @a[tag=mirror_arena_inside,distance=0..] subtitle {"text":"闪电 + 毒地 · 停止召唤","color":"gray"}
execute at @e[tag=mirror_arena_boss,limit=1] run playsound minecraft:entity.lightning_bolt.thunder master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 0.7
