# 标记本体主阵的实际目标（供双生共鸣/拓印 next_bonus 使用）。
# 本体 metal_main 按 zf_hold_ldl 选最近 1 个 monster：±1 = 5 格，±2..±4 = 10 格。
# 1.20.1 的 metal_main 在 after 钩子前已经清掉 metaltag，所以这里按同一规则重选；
# 目标若被主阵击杀则选不到，调用方必须按“无目标”处理，不能静默消费。
# @s=玩家；执行位置=主阵位置。结果 tag=mirror_main_target。
tag @e[tag=mirror_main_target] remove mirror_main_target
execute at @s if score @s zf_hold_ldl matches 1 run tag @e[tag=monster,distance=..5,sort=nearest,limit=1] add mirror_main_target
execute at @s if score @s zf_hold_ldl matches -1 run tag @e[tag=monster,distance=..5,sort=nearest,limit=1] add mirror_main_target
execute at @s if score @s zf_hold_ldl matches 2..4 run tag @e[tag=monster,distance=..10,sort=nearest,limit=1] add mirror_main_target
execute at @s if score @s zf_hold_ldl matches -4..-2 run tag @e[tag=monster,distance=..10,sort=nearest,limit=1] add mirror_main_target
