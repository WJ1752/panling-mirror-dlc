# 照心（镜统 0）：受击 5% 概率反射 10% 伤害。只给剑/斧（form 0..1）。
# 触发：plm:weapon/event/damaged（#pld:equipment_lock/when_damaged，位于 pre/damage/reduce_health 末尾）。
# 伤害量：只用 5t 生命快照差（本体 `damage` 追踪分数在已安装的包里没有写入者；
#         pld:pre/damage/update 无调用，故不再读它）。快照超过 10t 视为过期，不估值。
# 攻击者：when_damaged 没有攻击者上下文，用 6 格内最近的白名单敌人近似。
execute unless score @s wp_set matches 0 run return 0
execute unless score @s mirror_form matches 0..1 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
scoreboard players set #wp mirror_wtmp2 0
function plm:weapon/fx/zhe_guang/estimate
execute unless score #wp mirror_wtmp2 matches 1.. run return 0
execute if predicate plm:chance/5 run function plm:weapon/base/base_zhao_xin/reflect
