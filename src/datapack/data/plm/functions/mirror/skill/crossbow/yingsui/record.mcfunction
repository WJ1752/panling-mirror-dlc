# 影随 · 记录一个路径点（@s=玩家）
# 每 10t 一次（path_t 100,95,...，取 %10==0）；最多 10 点，超出丢最旧。
# 点存在玩家自己的 mirror_ys_xN/yN/zN（×100），不再写全服 storage crossbow_path。
scoreboard players operation #m mirror_skill_tmp = @s mirror_path_t
scoreboard players operation #m mirror_skill_tmp %= #const10 mirror_calc
execute unless score #m mirror_skill_tmp matches 0 run return 0

scoreboard players add @s mirror_path_n 1
execute if score @s mirror_path_n matches 11.. run function plm:mirror/skill/crossbow/yingsui/shift

execute if score @s mirror_path_n matches 1 store result score @s mirror_ys_x1 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 1 store result score @s mirror_ys_y1 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 1 store result score @s mirror_ys_z1 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 2 store result score @s mirror_ys_x2 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 2 store result score @s mirror_ys_y2 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 2 store result score @s mirror_ys_z2 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 3 store result score @s mirror_ys_x3 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 3 store result score @s mirror_ys_y3 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 3 store result score @s mirror_ys_z3 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 4 store result score @s mirror_ys_x4 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 4 store result score @s mirror_ys_y4 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 4 store result score @s mirror_ys_z4 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 5 store result score @s mirror_ys_x5 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 5 store result score @s mirror_ys_y5 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 5 store result score @s mirror_ys_z5 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 6 store result score @s mirror_ys_x6 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 6 store result score @s mirror_ys_y6 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 6 store result score @s mirror_ys_z6 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 7 store result score @s mirror_ys_x7 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 7 store result score @s mirror_ys_y7 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 7 store result score @s mirror_ys_z7 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 8 store result score @s mirror_ys_x8 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 8 store result score @s mirror_ys_y8 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 8 store result score @s mirror_ys_z8 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 9 store result score @s mirror_ys_x9 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 9 store result score @s mirror_ys_y9 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 9 store result score @s mirror_ys_z9 run data get entity @s Pos[2] 100
execute if score @s mirror_path_n matches 10 store result score @s mirror_ys_x10 run data get entity @s Pos[0] 100
execute if score @s mirror_path_n matches 10 store result score @s mirror_ys_y10 run data get entity @s Pos[1] 100
execute if score @s mirror_path_n matches 10 store result score @s mirror_ys_z10 run data get entity @s Pos[2] 100
