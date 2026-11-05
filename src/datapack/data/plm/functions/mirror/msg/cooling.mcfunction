# 冷却 actionbar：@s = 玩家（调用方负责先把剩余冷却写进 #mirror_msg_cd）
# 输入：#mirror_msg_cd mirror_msg = 剩余冷却（5t 单位；mirror_cd_a / mirror_cd_b 的口径）
# 输出：actionbar「冷却中 Ns」，N = ceil(cd/4)
# 单位换算：1 个 5t 单位 = 5t = 0.25s → 4 单位 = 1s；
# scoreboard 整数除法向下取整，所以 (cd + 3) / 4 即向上取整。
scoreboard players operation #mirror_msg_sec mirror_msg = #mirror_msg_cd mirror_msg
scoreboard players add #mirror_msg_sec mirror_msg 3
scoreboard players operation #mirror_msg_sec mirror_msg /= #const4 mirror_calc
# 防御：cd 为 0 或负值时也至少显示 1s（调用方本应只在 cd 1.. 时调用）
execute if score #mirror_msg_sec mirror_msg matches ..0 run scoreboard players set #mirror_msg_sec mirror_msg 1
title @s actionbar [{"text":"冷却中 ","color":"gray"},{"score":{"name":"#mirror_msg_sec","objective":"mirror_msg"},"color":"white"},{"text":"s","color":"gray"}]
