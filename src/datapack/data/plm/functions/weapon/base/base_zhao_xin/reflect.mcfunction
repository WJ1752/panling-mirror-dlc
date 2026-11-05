# 照心反射结算：10% 伤害 → 6 格内最近的白名单敌人。
# 输入：#wp mirror_wtmp2 = 本次受伤量（×100）；@s = 受伤玩家。
scoreboard players operation #temp entity_hurt_temp = #wp mirror_wtmp2
scoreboard players operation #temp entity_hurt_temp *= #const10 mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
execute unless score #temp entity_hurt_temp matches 1.. run return 0
tag @e[tag=wp_zhaoxin_cand] remove wp_zhaoxin_cand
execute at @s run tag @e[tag=monster,distance=..6] add wp_zhaoxin_cand
execute at @s run tag @e[tag=mirror_boss,distance=..6] add wp_zhaoxin_cand
execute at @s run tag @e[tag=mirror_summon,distance=..6] add wp_zhaoxin_cand
execute at @s run tag @e[tag=wp_zhaoxin_cand,sort=nearest,limit=1] add wp_zhaoxin_target
execute unless entity @e[tag=wp_zhaoxin_target,limit=1] run return 0
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=wp_zhaoxin_target,limit=1] add mirror_dmg_target
execute as @e[tag=wp_zhaoxin_target,limit=1] at @s run particle minecraft:dust 0.85 0.95 1 1 ~ ~1 ~ 0.3 0.4 0.3 0.02 10
function plm:mirror/damage/armor
tag @e[tag=wp_zhaoxin_cand] remove wp_zhaoxin_cand
tag @e[tag=wp_zhaoxin_target] remove wp_zhaoxin_target
