# 双生套装 5t（由 plm:mirror/set/tick 调用，顶层 console/schedule 源）
# 1) 逐玩家刷新 2/4/真影律分档与共鸣上限
# 2) 清理过期的「相克」标记（只扫带 tag 的敌人，不做全服 tick）
execute as @a run function plm:mirror/set/twin/tick_player
execute as @e[tag=mirror_element_break_active] if score @s mirror_element_break < #sys mirror_game_time run tag @s remove mirror_element_break_active
# 主阵留下但倒影阵没打到的同中标记：到期就地清掉（只扫带 tag 的敌人）
execute as @e[tag=mirror_resonance_mark] if score @s mirror_resonance_target < #sys mirror_game_time run tag @s remove mirror_resonance_mark
