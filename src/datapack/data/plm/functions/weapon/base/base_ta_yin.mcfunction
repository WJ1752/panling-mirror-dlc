# 拓印（镜统 5）：击杀时 5% 概率使 3 格内敌人显影 1s。只给拓印炉（form 5）。
# 触发：plm:weapon/event/kill（player_killed_entity reward）。
# 限制：阵法（zf）击杀不 credit 玩家，不会触发本入口；这条留在 gaps。
execute unless score @s wp_set matches 5 run return 0
execute unless score @s mirror_form matches 5 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute if predicate plm:chance/5 run function plm:weapon/base/base_ta_yin/apply
