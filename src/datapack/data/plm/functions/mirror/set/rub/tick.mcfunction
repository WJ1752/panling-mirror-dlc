# 拓印套装 5t（由 plm:mirror/set/tick 调用，顶层 console/schedule 源）
# 2 件套：印上限 5；4 件套：放印后下一本体阵法 +5%；真影律：放印免耗（120s 内部冷却）
execute as @a run function plm:mirror/set/rub/tier
# 每 5t 减 1：480 = 120s（设计 §1.2/§2.6.2 的 120s 口径）
execute as @a[scores={mirror_rub_true_cd=1..}] run scoreboard players remove @s mirror_rub_true_cd 1
