# 磨镜台冷却倒计时（每 5 tick 一次即可，冷却 10 tick）
execute as @a[scores={mirror_tbl_cool=1..}] run scoreboard players remove @s mirror_tbl_cool 5
execute as @a[scores={mirror_tbl_cool=..-1}] run scoreboard players set @s mirror_tbl_cool 0
