# 影随 · 写采样点（@s=斧玩家，at @s），由 axe/tick 每 10t 调用一次。
# 每玩家独立 6 点环形缓冲（记分板），不再使用全服共享 storage plm:mirror axe.path。
# 站桩不留痕：与上一个采样点水平距离 <0.5 格且 walk_one_cm 增量 <50 时直接返回，
# 不再因为“上一点超过 60 tick”而在原地追加新点。
#
# 槽位：mirror_trail_i = 1..6；mirror_trail_n = 已有点数 0..6
# 坐标 ×100（1 = 0.01 格）；mirror_trail_t* = 采样时 gametime。
scoreboard players set #axe_walk mirror_wtmp3 0
execute store result score #axe_walk mirror_wtmp3 run scoreboard players get @s mirror_walk_stat
execute store result score #axe_ex mirror_wtmp run data get entity @s Pos[0] 100
execute store result score #axe_ey mirror_wtmp9 run data get entity @s Pos[1] 100
execute store result score #axe_ez mirror_wtmp2 run data get entity @s Pos[2] 100

# ---- 首次采样：只记录基准，不产生影迹点 ----
execute unless score @s mirror_trail_init matches 1.. run scoreboard players operation @s mirror_trail_lx = #axe_ex mirror_wtmp
execute unless score @s mirror_trail_init matches 1.. run scoreboard players operation @s mirror_trail_lz = #axe_ez mirror_wtmp2
execute unless score @s mirror_trail_init matches 1.. run scoreboard players operation @s mirror_trail_lw = #axe_walk mirror_wtmp3
execute unless score @s mirror_trail_init matches 1.. run scoreboard players set @s mirror_trail_init 1
# 首次采样时基准刚写入，下面的“站立/原地抖动”判定会自然 return，不会留下影迹点。

# ---- 与上一个采样点的水平距离² 与 walk 增量 ----
scoreboard players operation #axe_walkd mirror_wtmp4 = #axe_walk mirror_wtmp3
scoreboard players operation #axe_walkd mirror_wtmp4 -= @s mirror_trail_lw
scoreboard players operation #axe_dx mirror_wtmp5 = #axe_ex mirror_wtmp
scoreboard players operation #axe_dx mirror_wtmp5 -= @s mirror_trail_lx
scoreboard players operation #axe_dz mirror_wtmp6 = #axe_ez mirror_wtmp2
scoreboard players operation #axe_dz mirror_wtmp6 -= @s mirror_trail_lz
scoreboard players operation #axe_d2 mirror_wtmp7 = #axe_dx mirror_wtmp5
scoreboard players operation #axe_d2 mirror_wtmp7 *= #axe_dx mirror_wtmp5
scoreboard players operation #axe_tmp mirror_wtmp8 = #axe_dz mirror_wtmp6
scoreboard players operation #axe_tmp mirror_wtmp8 *= #axe_dz mirror_wtmp6
scoreboard players operation #axe_d2 mirror_wtmp7 += #axe_tmp mirror_wtmp8

# 站着不动（或只是原地抖动）：不写点。这里不再看 age。
execute if score #axe_d2 mirror_wtmp7 matches ..2499 if score #axe_walkd mirror_wtmp4 matches ..49 run return 0

# ---- 写环形槽 ----
scoreboard players add @s mirror_trail_i 1
execute if score @s mirror_trail_i matches 7.. run scoreboard players set @s mirror_trail_i 1
execute if score @s mirror_trail_i matches 1 run scoreboard players operation @s mirror_trail_x1 = #axe_ex mirror_wtmp
execute if score @s mirror_trail_i matches 1 run scoreboard players operation @s mirror_trail_y1 = #axe_ey mirror_wtmp9
execute if score @s mirror_trail_i matches 1 run scoreboard players operation @s mirror_trail_z1 = #axe_ez mirror_wtmp2
execute if score @s mirror_trail_i matches 1 run scoreboard players operation @s mirror_trail_t1 = #sys mirror_game_time
execute if score @s mirror_trail_i matches 2 run scoreboard players operation @s mirror_trail_x2 = #axe_ex mirror_wtmp
execute if score @s mirror_trail_i matches 2 run scoreboard players operation @s mirror_trail_y2 = #axe_ey mirror_wtmp9
execute if score @s mirror_trail_i matches 2 run scoreboard players operation @s mirror_trail_z2 = #axe_ez mirror_wtmp2
execute if score @s mirror_trail_i matches 2 run scoreboard players operation @s mirror_trail_t2 = #sys mirror_game_time
execute if score @s mirror_trail_i matches 3 run scoreboard players operation @s mirror_trail_x3 = #axe_ex mirror_wtmp
execute if score @s mirror_trail_i matches 3 run scoreboard players operation @s mirror_trail_y3 = #axe_ey mirror_wtmp9
execute if score @s mirror_trail_i matches 3 run scoreboard players operation @s mirror_trail_z3 = #axe_ez mirror_wtmp2
execute if score @s mirror_trail_i matches 3 run scoreboard players operation @s mirror_trail_t3 = #sys mirror_game_time
execute if score @s mirror_trail_i matches 4 run scoreboard players operation @s mirror_trail_x4 = #axe_ex mirror_wtmp
execute if score @s mirror_trail_i matches 4 run scoreboard players operation @s mirror_trail_y4 = #axe_ey mirror_wtmp9
execute if score @s mirror_trail_i matches 4 run scoreboard players operation @s mirror_trail_z4 = #axe_ez mirror_wtmp2
execute if score @s mirror_trail_i matches 4 run scoreboard players operation @s mirror_trail_t4 = #sys mirror_game_time
execute if score @s mirror_trail_i matches 5 run scoreboard players operation @s mirror_trail_x5 = #axe_ex mirror_wtmp
execute if score @s mirror_trail_i matches 5 run scoreboard players operation @s mirror_trail_y5 = #axe_ey mirror_wtmp9
execute if score @s mirror_trail_i matches 5 run scoreboard players operation @s mirror_trail_z5 = #axe_ez mirror_wtmp2
execute if score @s mirror_trail_i matches 5 run scoreboard players operation @s mirror_trail_t5 = #sys mirror_game_time
execute if score @s mirror_trail_i matches 6 run scoreboard players operation @s mirror_trail_x6 = #axe_ex mirror_wtmp
execute if score @s mirror_trail_i matches 6 run scoreboard players operation @s mirror_trail_y6 = #axe_ey mirror_wtmp9
execute if score @s mirror_trail_i matches 6 run scoreboard players operation @s mirror_trail_z6 = #axe_ez mirror_wtmp2
execute if score @s mirror_trail_i matches 6 run scoreboard players operation @s mirror_trail_t6 = #sys mirror_game_time

scoreboard players add @s mirror_trail_n 1
execute if score @s mirror_trail_n matches 7.. run scoreboard players set @s mirror_trail_n 6

# 更新基准（上次采样位置/步数）
scoreboard players operation @s mirror_trail_lx = #axe_ex mirror_wtmp
scoreboard players operation @s mirror_trail_lz = #axe_ez mirror_wtmp2
scoreboard players operation @s mirror_trail_lw = #axe_walk mirror_wtmp3

# 视觉：采样点就地铺黑色 dust（旧点不重绘；1.20.1 无法用 storage 坐标定位粒子）
particle minecraft:dust 0.05 0.05 0.05 1 ~ ~0.1 ~ 0.35 0.12 0.35 0.005 6
