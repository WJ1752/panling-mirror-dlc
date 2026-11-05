# 影随 · 处理路径第 i 个点（@s=玩家）
# 每玩家独立槽位：从 mirror_ys_xN/yN/zN 读第 i 个点，2 格取样（首个点无条件取），
# 每点一支齐射箭；最多取 8 个点。不再读/清全服 storage crossbow_path。
execute if score @s mirror_path_taken matches 8.. run return 0
scoreboard players add @s mirror_path_i 1
execute if score @s mirror_path_i > #ys_n mirror_path_ysn run return 0

execute if score @s mirror_path_i matches 1 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x1
execute if score @s mirror_path_i matches 1 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y1
execute if score @s mirror_path_i matches 1 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z1
execute if score @s mirror_path_i matches 2 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x2
execute if score @s mirror_path_i matches 2 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y2
execute if score @s mirror_path_i matches 2 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z2
execute if score @s mirror_path_i matches 3 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x3
execute if score @s mirror_path_i matches 3 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y3
execute if score @s mirror_path_i matches 3 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z3
execute if score @s mirror_path_i matches 4 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x4
execute if score @s mirror_path_i matches 4 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y4
execute if score @s mirror_path_i matches 4 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z4
execute if score @s mirror_path_i matches 5 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x5
execute if score @s mirror_path_i matches 5 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y5
execute if score @s mirror_path_i matches 5 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z5
execute if score @s mirror_path_i matches 6 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x6
execute if score @s mirror_path_i matches 6 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y6
execute if score @s mirror_path_i matches 6 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z6
execute if score @s mirror_path_i matches 7 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x7
execute if score @s mirror_path_i matches 7 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y7
execute if score @s mirror_path_i matches 7 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z7
execute if score @s mirror_path_i matches 8 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x8
execute if score @s mirror_path_i matches 8 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y8
execute if score @s mirror_path_i matches 8 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z8
execute if score @s mirror_path_i matches 9 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x9
execute if score @s mirror_path_i matches 9 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y9
execute if score @s mirror_path_i matches 9 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z9
execute if score @s mirror_path_i matches 10 run scoreboard players operation #cbpx mirror_wtmp = @s mirror_ys_x10
execute if score @s mirror_path_i matches 10 run scoreboard players operation #cbpy mirror_wtmp2 = @s mirror_ys_y10
execute if score @s mirror_path_i matches 10 run scoreboard players operation #cbpz mirror_wtmp3 = @s mirror_ys_z10

scoreboard players set #take mirror_wtmp5 0
execute if score @s mirror_path_i matches 1 run scoreboard players set #take mirror_wtmp5 1
execute if score @s mirror_path_i matches 2.. run function plm:mirror/skill/crossbow/yingsui/spacing
execute if score #take mirror_wtmp5 matches 0 run return 0

# 记录上一个被取的点（mirror_yingsui_x/z 专用于影随，aim 不碰）
scoreboard players operation #lx mirror_yingsui_x = #cbpx mirror_wtmp
scoreboard players operation #lz mirror_yingsui_z = #cbpz mirror_wtmp3
scoreboard players add @s mirror_path_taken 1
# 箭生成高度 = 点 y + 1.2
scoreboard players add #cbpy mirror_wtmp2 120
function plm:mirror/skill/crossbow/yingsui/point
