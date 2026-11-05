# 印上限收敛 + actionbar（2 件套动态 3/5）
function plm:mirror/set/rub/tier
execute if score @s mirror_rub_stack > @s mirror_rub_max run scoreboard players operation @s mirror_rub_stack = @s mirror_rub_max
execute if score @s mirror_rub_stack matches ..-1 run scoreboard players set @s mirror_rub_stack 0
function plm:mirror/skill/furnace/rub/bar
