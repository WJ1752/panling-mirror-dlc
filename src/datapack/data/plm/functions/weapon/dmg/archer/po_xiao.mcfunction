# 破晓（po_xiao）— target（弓/弩命中侧）
# 目标生命 >=90% 时 +15%；命中侧读取目标 HP（射出时没有目标，故不在 ctx/archer 结算）
execute unless score @s wp_affix_dmg_po_xiao matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
function plm:weapon/ctx/target_hp
execute unless score #wp mirror_wtmp matches 90.. run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_po_xiao
