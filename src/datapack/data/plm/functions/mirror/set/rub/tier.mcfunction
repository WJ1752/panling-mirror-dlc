# 拓印套装单玩家分档（@s=玩家）
# 2 件套 = 防具件数 >= 2；印上限 3 -> 5，并把超出的印收敛。
scoreboard players set #t mirror_set_tmp 5
function plm:mirror/set/can/tier
scoreboard players set @s mirror_rub_max 3
execute if score @s mirror_set_count matches 2.. run scoreboard players set @s mirror_rub_max 5
execute if score @s mirror_rub_stack > @s mirror_rub_max run scoreboard players operation @s mirror_rub_stack = @s mirror_rub_max
execute if score @s mirror_rub_stack matches ..-1 run scoreboard players set @s mirror_rub_stack 0
# 真影律免耗冷却未设置时归 0（matches 0.. 对未设置分数为假）
execute unless score @s mirror_rub_true_cd matches 0.. run scoreboard players set @s mirror_rub_true_cd 0
