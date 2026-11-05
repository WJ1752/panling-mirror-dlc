# 镜花绽放：30% 箭伤 → 5 格内最近的「其他」白名单目标；没有其他目标时补原目标。
# 调用方约定：archer_hit 用 `execute at <命中目标> run function` 调用本函数，
# 所以下面的候选选择器以「命中目标」为圆心（不是射手位置）。
# 单位：#temp player_cause_1damage 是 ×10（10=1HP），entity_hurt_temp 是 ×100；
#       dmg10 × 30 / 10 = 30（= 30% 的 ×100 值）。
scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage
scoreboard players operation #temp entity_hurt_temp *= #const30 mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #const10 mirror_calc
execute unless score #temp entity_hurt_temp matches 1.. run return 0
tag @e[tag=wp_jinghua_cand] remove wp_jinghua_cand
tag @e[tag=monster,distance=..5,tag=!plm_ctx_target] add wp_jinghua_cand
tag @e[tag=mirror_boss,distance=..5,tag=!plm_ctx_target] add wp_jinghua_cand
tag @e[tag=mirror_summon,distance=..5,tag=!plm_ctx_target] add wp_jinghua_cand
tag @e[tag=wp_jinghua_cand,sort=nearest,limit=1] add wp_jinghua_target
execute unless entity @e[tag=wp_jinghua_target,limit=1] run tag @e[tag=plm_ctx_target,limit=1] add wp_jinghua_target
execute unless entity @e[tag=wp_jinghua_target,limit=1] run return 0
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=wp_jinghua_target,limit=1] add mirror_dmg_target
execute as @e[tag=wp_jinghua_target,limit=1] at @s run particle minecraft:dust 0.55 0.9 1 1 ~ ~1 ~ 0.35 0.4 0.35 0.02 10
function plm:mirror/damage/armor
tag @e[tag=wp_jinghua_cand] remove wp_jinghua_cand
tag @e[tag=wp_jinghua_target] remove wp_jinghua_target
