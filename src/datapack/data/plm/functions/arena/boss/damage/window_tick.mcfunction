# 5s（100t）伤害窗口倒计时；归零后重开窗口
execute if score #boss mirror_boss_window_timer matches 1.. run scoreboard players remove #boss mirror_boss_window_timer 1
execute if score #boss mirror_boss_window_timer matches ..0 run function plm:arena/boss/damage/window_reset
