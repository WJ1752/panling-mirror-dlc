# 残影射击：20% 箭伤 → 8 格内最近的白名单敌人。
# 调用方约定：archer_hit 用 `execute at <命中目标> run function` 调用，候选以命中目标为圆心；
# @s 仍是射手（下面的 `at @s` 粒子才是射手脚下的残影）。
# 单位：dmg10 × 2 = 20% 的 ×100 值。
scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage
scoreboard players operation #temp entity_hurt_temp *= #const2 mirror_calc
execute unless score #temp entity_hurt_temp matches 1.. run return 0
tag @e[tag=wp_canying_cand] remove wp_canying_cand
tag @e[tag=monster,distance=..8] add wp_canying_cand
tag @e[tag=mirror_boss,distance=..8] add wp_canying_cand
tag @e[tag=mirror_summon,distance=..8] add wp_canying_cand
tag @e[tag=wp_canying_cand,sort=nearest,limit=1] add wp_canying_target
execute unless entity @e[tag=wp_canying_target,limit=1] run return 0
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=wp_canying_target,limit=1] add mirror_dmg_target
# 残影：玩家脚下的 1s 镜影粒子（近似表现）
execute at @s run particle minecraft:dust 0.5 0.8 1 1 ~ ~1 ~ 0.4 0.8 0.4 0.01 20
execute as @e[tag=wp_canying_target,limit=1] at @s run particle minecraft:dust 0.5 0.8 1 1 ~ ~1 ~ 0.3 0.4 0.3 0.02 8
function plm:mirror/damage/armor
tag @e[tag=wp_canying_cand] remove wp_canying_cand
tag @e[tag=wp_canying_target] remove wp_canying_target
