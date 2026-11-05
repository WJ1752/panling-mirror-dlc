# 技能箭命中结算（@s=射手；目标已打 mirror_arrow_hit）
execute at @e[tag=mirror_arrow_hit,limit=1] run particle minecraft:dust 0.55 0.25 0.95 1 ~ ~1 ~ 0.25 0.25 0.25 0.02 8
execute at @e[tag=mirror_arrow_hit,limit=1] run playsound minecraft:entity.arrow.hit master @a ~ ~ ~ 0.7 1.2
# 裂影 2 件套的影伤基数：本次弩箭实际伤害（#temp 100=1HP → player_cause 10=1HP）
scoreboard players operation #temp player_cause_1damage = #temp entity_hurt_temp
scoreboard players operation #temp player_cause_1damage /= #const10 mirror_calc
execute as @e[tag=mirror_arrow_hit,limit=1] run tag @s add mirror_dmg_target
# #temp entity_hurt_temp 已由 hit_check 按基伤×速度写好
tag @s add mirror_arena_skill_arrow
function plm:mirror/damage/armor
tag @s remove mirror_arena_skill_arrow
# 裂影 2 件套：技能箭命中追加一次 15% 影伤（原伤害结算之后；每箭一次）
tag @e[tag=plm_ctx_target] remove plm_ctx_target
execute as @e[tag=mirror_arrow_hit,limit=1] run tag @s add plm_ctx_target
scoreboard players set @s mirror_axe_2_crit 0
execute if entity @e[tag=plm_ctx_target,limit=1] run function plm:mirror/set/lie/on_hit
tag @e[tag=plm_ctx_target] remove plm_ctx_target
