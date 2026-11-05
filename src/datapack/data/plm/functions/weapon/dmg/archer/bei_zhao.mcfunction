# 背照（bei_zhao）— target（弓/弩命中侧）
# 攻击者位于目标背后 120° 锥内 +15%；命中侧用 ctx/target_behind（目标朝向为参考系）
execute unless score @s wp_affix_dmg_bei_zhao matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
function plm:weapon/ctx/target_behind
execute unless score #wp mirror_wtmp10 matches 1 run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_bei_zhao
