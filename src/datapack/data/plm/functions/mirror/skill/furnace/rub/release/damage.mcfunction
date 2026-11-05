# 放印 4 格 AoE 的目标收集（@s = 玩家）
# 伤害目标：monster / mirror_boss / mirror_summon（CONTRACT §4 白名单）
tag @e[tag=rub_hit] remove rub_hit
tag @e[tag=rub_current] remove rub_current
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
execute at @s run tag @e[tag=monster,distance=..4] add rub_hit
execute at @s run tag @e[tag=mirror_boss,distance=..4] add rub_hit
execute at @s run tag @e[tag=mirror_summon,distance=..4] add rub_hit
function plm:mirror/skill/furnace/rub/release/loop
tag @e[tag=rub_hit] remove rub_hit
tag @e[tag=rub_current] remove rub_current
