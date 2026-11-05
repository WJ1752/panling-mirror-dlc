# @s = 主人；#skill atk/ratio 已由倒影写入；目标带 mirror_dmg_target
scoreboard players operation #skill mirror_skill_tmp = #skill mirror_skill_atk
scoreboard players operation #skill mirror_skill_tmp *= #const10 mirror_calc
scoreboard players operation #skill mirror_skill_tmp *= #skill mirror_skill_ratio
scoreboard players operation #skill mirror_skill_tmp /= #const100 mirror_calc
scoreboard players operation #temp entity_hurt_temp = #skill mirror_skill_tmp
function plm:mirror/set/zhao/vuln
function plm:mirror/damage/armor
execute as @e[tag=mirror_dmg_target,limit=1] at @s run particle minecraft:crit ~ ~1 ~ 0.3 0.4 0.3 0.05 6
