# @s=主人；#skill mirror_skill_tmp=影伤；目标带 mirror_dmg_target
# 红色斜劈粒子必须在 armor 之前发：plm:mirror/damage/armor 结算后会清掉
# mirror_dmg_target，之后再按该 tag 选目标会选空，粒子永远不出现（#38）。
execute as @e[tag=mirror_dmg_target,limit=1] at @s run particle minecraft:dust 0.9 0.1 0.1 1 ~ ~1 ~ 0.3 0.3 0.3 0.03 8
scoreboard players operation #temp entity_hurt_temp = #skill mirror_skill_tmp
function plm:mirror/set/zhao/vuln
function plm:mirror/damage/armor
