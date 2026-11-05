# 镜花套装 5t tick
# 花影到期/上限在 bow/route、bow/flower_add、普通箭命中入口处理；这里清过期花影与 4 件套窗口。
execute as @a[scores={mirror_flower=1..}] if score @s mirror_flower_until <= #sys mirror_game_time run scoreboard players set @s mirror_flower 0
execute as @a[scores={mirror_bow_4_until=1..}] if score @s mirror_bow_4_until <= #sys mirror_game_time run scoreboard players set @s mirror_bow_4_bonus 0
execute as @a[scores={mirror_bow_4_until=1..}] if score @s mirror_bow_4_until <= #sys mirror_game_time run scoreboard players set @s mirror_bow_4_until 0
# 防御：bonus 还在但 until 已被其它路径清零时，别让旧加成挂到下一箭
execute as @a[scores={mirror_bow_4_bonus=1..}] unless score @s mirror_bow_4_until >= #sys mirror_game_time run scoreboard players set @s mirror_bow_4_bonus 0
