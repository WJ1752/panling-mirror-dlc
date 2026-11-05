# 残影（镜统 3）：攻击时 5% 概率留下 1s 残影，向最近敌人射一箭（20% 强度）。只给弓/弩。
# 触发：plm:weapon/dmg/archer_hit（命中侧）。
# 调用方必须 `execute at <命中目标> run function`，shot 的候选半径才以目标为圆心。
# 口径：不生成真实箭实体（1.20.1 无可靠的 1s 自毁载体），用粒子残影 + 20% 箭伤的即时射击近似。
execute unless score @s wp_set matches 3 run return 0
execute unless score @s mirror_form matches 2..3 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score #temp player_cause_1damage matches 1.. run return 0
execute if predicate plm:chance/5 run function plm:weapon/base/base_can_ying/shot
