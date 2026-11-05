# @s = 敌人；窗口到 game_time+20（1s，20 tick）；owner = 施放者 player_uid
scoreboard players operation @s mirror_resonance_target = #sys mirror_game_time
scoreboard players add @s mirror_resonance_target 20
scoreboard players operation @s mirror_resonance_owner = #tw_res_owner mirror_skill_tmp
tag @s add mirror_resonance_mark
# 4 件套：满共鸣时主阵命中给目标挂「相克」（10s）
execute if score #tw_4pc mirror_twin_4_until matches 1 run function plm:mirror/set/twin/element_break
