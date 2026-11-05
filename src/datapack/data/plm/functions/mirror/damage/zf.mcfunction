# DLC 阵法伤害包装（设计 §2.5.1 的 zf 管路口径）
# @s = 攻击者（玩家）；#temp entity_hurt_temp = 2 位小数（100 = 1 HP）；目标已打 mirror_dmg_target。
# 作用：给目标打 mirror_formation 标识，走一次 public_damage_entity（护甲/保护/一次 Resistance），
# 再移除标识。本体没有可复用的通用元素伤害入口；本包装就是 DLC 的阵法伤害管路，
# mirror_formation 在这里被消费，不再只是遗留 tag。
tag @e[tag=mirror_formation] remove mirror_formation
execute as @e[tag=mirror_dmg_target,limit=1] run tag @s add mirror_formation
function plm:mirror/damage/armor
tag @e[tag=mirror_formation] remove mirror_formation
