# 碎镜易伤：@s=攻击者；#temp entity_hurt_temp 已设置；目标已打 mirror_dmg_target。
# 目标在 mirror_shatter_until 之前受到的镜武伤害 ×1.15。
# 说明：1.20.1 无法在 vanilla 受击事件里改原始伤害，因此该易伤只覆盖 DLC 镜武的伤害包装
# （近战踏影/镜映反射/裂痕/重影/镜花/分影）；vanilla 普攻与其他分支的伤害见 blocker。
execute if score @e[tag=mirror_dmg_target,limit=1] mirror_shatter_until matches 1.. if score @e[tag=mirror_dmg_target,limit=1] mirror_shatter_until >= #sys mirror_game_time run scoreboard players set #zhao_vuln mirror_calc 115
execute if score @e[tag=mirror_dmg_target,limit=1] mirror_shatter_until matches 1.. if score @e[tag=mirror_dmg_target,limit=1] mirror_shatter_until >= #sys mirror_game_time run scoreboard players operation #temp entity_hurt_temp *= #zhao_vuln mirror_calc
execute if score @e[tag=mirror_dmg_target,limit=1] mirror_shatter_until matches 1.. if score @e[tag=mirror_dmg_target,limit=1] mirror_shatter_until >= #sys mirror_game_time run scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
