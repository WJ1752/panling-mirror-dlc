# 镜花（镜统 2）：箭矢命中时 5% 概率绽放一次 30% 伤害。只给弓/弩（form 2..3）。
# 触发：plm:weapon/dmg/archer_hit（命中侧；射出时没有目标）。
# 调用方必须 `execute at <命中目标> run function`，bloom 的候选半径才以目标为圆心。
# 输入：#temp player_cause_1damage = 本次箭伤（×10）；plm_ctx_target = 命中目标。
execute unless score @s wp_set matches 2 run return 0
execute unless score @s mirror_form matches 2..3 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score #temp player_cause_1damage matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute if predicate plm:chance/5 run function plm:weapon/base/base_jing_hua/bloom
