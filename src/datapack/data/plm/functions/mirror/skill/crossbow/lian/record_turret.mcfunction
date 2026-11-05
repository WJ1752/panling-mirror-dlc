# 弩机箭命中：2 件套才计入连影；第 4 发必须由玩家自己的箭触发
execute unless score @s mirror_turret_max matches 2.. run return 0
scoreboard players set #lian_nopower mirror_skill_perfect 1
function plm:mirror/skill/crossbow/lian/record
