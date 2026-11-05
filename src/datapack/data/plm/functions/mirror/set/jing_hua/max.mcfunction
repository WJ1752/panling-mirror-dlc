# 镜花花影上限：2 件套（防具件数≥2）上限 5；否则沿用基础 3。
# @s=玩家。防具件数 = mirror_set_c - (武器镜统==镜花 ? mirror_set_weapon : 0)。
scoreboard players set @s mirror_set_count 0
scoreboard players operation @s mirror_set_count = @s mirror_set_c
execute if score @s mirror_set matches 2 run scoreboard players operation @s mirror_set_count -= @s mirror_set_weapon
scoreboard players set @s mirror_flower_max 3
execute if score @s mirror_set_count matches 2.. run scoreboard players set @s mirror_flower_max 5
