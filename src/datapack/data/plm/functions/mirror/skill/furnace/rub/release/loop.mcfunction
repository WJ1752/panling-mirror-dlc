# 逐个结算 4 格 AoE（每次取一个 rub_hit，结算后移除再递归）
# @s = 玩家；#temp 在玩家上下文里写一次，damage/armor 会作用到 mirror_dmg_target
execute unless entity @e[tag=rub_hit,limit=1] run return 0
execute as @e[tag=rub_hit,limit=1] run tag @s add rub_current
execute as @e[tag=rub_current] run tag @s add mirror_dmg_target
scoreboard players operation #temp entity_hurt_temp = #rub mirror_rub_extra
# 照妖：命中前已经显形的目标吃 +15%（词条到 23%）
# Id 在 1.20.1 的 ActiveEffects 里是 int（NBT 显示 Id: 24，没有 b 后缀），用路径过滤查
execute as @e[tag=rub_current,limit=1] if data entity @s ActiveEffects[{Id:24}] run function plm:mirror/skill/furnace/rub/release/zhao
function plm:mirror/damage/armor
execute as @e[tag=rub_current] run function plm:mirror/skill/furnace/rub/release/victim
execute as @e[tag=rub_current] run tag @s remove rub_hit
execute as @e[tag=rub_current] run tag @s remove rub_current
function plm:mirror/skill/furnace/rub/release/loop
