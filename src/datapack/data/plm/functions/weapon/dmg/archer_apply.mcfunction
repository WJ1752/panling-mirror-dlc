# 弓/弩五纹追加伤害。输入：
#   @s mirror_ctx_extra = 本次命中有效词条合计（百分点×10）
#   #temp player_cause_1damage = 命中侧还原的箭伤（×10，10 = 1 HP）
#   plm_ctx_target = 本次命中目标
# 输出：#temp entity_hurt_temp（×100）→ 本体护甲/保护包装。
# 单位：dmg10 × pp10 = 100×D×P；/100 = D×P = 追加伤害在 ×100 下的值。
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score #temp player_cause_1damage matches 1.. run return 0
execute unless score @s mirror_ctx_extra matches 1.. run return 0

scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage
scoreboard players operation #temp entity_hurt_temp *= @s mirror_ctx_extra
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc

tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=plm_ctx_target,limit=1] add mirror_dmg_target
execute if score #temp entity_hurt_temp matches 1.. run function plm:mirror/damage/armor
execute if score #temp entity_hurt_temp matches ..0 run tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
