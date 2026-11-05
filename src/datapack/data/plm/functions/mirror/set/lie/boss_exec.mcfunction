# 裂痕 4 件套 Boss 追加 60%：@s=玩家；plm_ctx_target=目标；#skill mirror_skill_lie=本次引爆伤害（×100）。
scoreboard players set #lie60 mirror_calc 60
scoreboard players set #lie100 mirror_calc 100
scoreboard players operation #temp entity_hurt_temp = #skill mirror_skill_lie
scoreboard players operation #temp entity_hurt_temp *= #lie60 mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #lie100 mirror_calc
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=plm_ctx_target,limit=1] add mirror_dmg_target
function plm:mirror/set/zhao/vuln
function plm:mirror/damage/armor
execute as @e[tag=plm_ctx_target,limit=1] at @s run particle minecraft:dust 0.9 0.1 0.1 1 ~ ~1 ~ 0.5 0.5 0.5 0.05 16
