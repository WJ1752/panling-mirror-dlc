# 照心剑 · 踏影：单个玩家的 5t 采样（@s=玩家；调用处已 at @s）
# 位移单位 ×100（1 = 0.01 格）。水平距离用 |dx|+|dz| 的 Manhattan 近似，
# 与设计 §2.1.3「水平距离」一致；只取 X/Z，所以竖直坠落本身不累计。
#
# 状态：
#   mirror_taying_last_x / last_z  上次采样坐标（×100）
#   mirror_taying_dx / dz          本次增量（×100，已取绝对值）
#   mirror_taying_dist             累计距离（×100）；初始化时用 1 当「已初始化」标记
#   mirror_taying_buff / cd        剩余 tick（由 tick.mcfunction 每 5t 减 5）

# 1) 当前坐标先放到全局临时量；dx/dz 要留作本次增量
execute store result score #taying_x mirror_calc run data get entity @s Pos[0] 100
execute store result score #taying_z mirror_calc run data get entity @s Pos[2] 100

# 防御：累计值若被外部写成负数，先归零
execute if score @s mirror_taying_dist matches ..-1 run scoreboard players set @s mirror_taying_dist 0

# 2) 首次/清理后初始化：last 为 0,0 且无累计/无 buff/无 cd 时，只记录起点，本 tick 不计位移。
#    初始化后 dist=1 作为「已初始化」标记（0.01 格，可忽略），避免在原点反复初始化。
scoreboard players set #taying_init mirror_calc 0
execute if score @s mirror_taying_dist matches 0 if score @s mirror_taying_buff matches 0 if score @s mirror_taying_cd matches 0 if score @s mirror_taying_last_x matches 0 if score @s mirror_taying_last_z matches 0 run scoreboard players set #taying_init mirror_calc 1
execute if score #taying_init mirror_calc matches 1 run scoreboard players operation @s mirror_taying_last_x = #taying_x mirror_calc
execute if score #taying_init mirror_calc matches 1 run scoreboard players operation @s mirror_taying_last_z = #taying_z mirror_calc
execute if score #taying_init mirror_calc matches 1 run scoreboard players set @s mirror_taying_dist 1
execute if score #taying_init mirror_calc matches 1 run return 0

# 3) 增量 = 当前 - last，再取绝对值
scoreboard players operation @s mirror_taying_dx = #taying_x mirror_calc
scoreboard players operation @s mirror_taying_dx -= @s mirror_taying_last_x
scoreboard players operation @s mirror_taying_dz = #taying_z mirror_calc
scoreboard players operation @s mirror_taying_dz -= @s mirror_taying_last_z
scoreboard players set #taying_neg mirror_calc -1
execute if score @s mirror_taying_dx matches ..-1 run scoreboard players operation @s mirror_taying_dx *= #taying_neg mirror_calc
execute if score @s mirror_taying_dz matches ..-1 run scoreboard players operation @s mirror_taying_dz *= #taying_neg mirror_calc

# 先更新 last：后面无论走哪个分支，都不会把本次位移重复计入
scoreboard players operation @s mirror_taying_last_x = #taying_x mirror_calc
scoreboard players operation @s mirror_taying_last_z = #taying_z mirror_calc

# 4) 传送：|dx|+|dz| ≥1000（10 格 / 5t = 40 格/s，快于冲刺/骑马）视为传送，只更新 last，不计累计。
#    更小的传送没有事件可读，无法与真实位移区分；这里是无传送 objective 时的阈值近似。
scoreboard players operation #taying_move mirror_calc = @s mirror_taying_dx
scoreboard players operation #taying_move mirror_calc += @s mirror_taying_dz
execute if score #taying_move mirror_calc matches 1000.. run return 0

# 5) buff/冷却期间移动不累计，并清空累计（冷却结束后重新跑满 4 格）
execute if score @s mirror_taying_cd matches 1.. run scoreboard players set @s mirror_taying_dist 0
execute if score @s mirror_taying_cd matches 1.. run return 0
execute if score @s mirror_taying_buff matches 1.. run scoreboard players set @s mirror_taying_dist 0
execute if score @s mirror_taying_buff matches 1.. run return 0

# 6) 累计；脚下白色镜尘按 5t 粒度近似「每 1 格」（设计 §2.1.3 的视觉要求）
scoreboard players operation @s mirror_taying_dist += @s mirror_taying_dx
scoreboard players operation @s mirror_taying_dist += @s mirror_taying_dz
execute unless score @s mirror_taying_dx matches 0 run particle minecraft:end_rod ~ ~0.1 ~ 0.2 0.02 0.2 0.005 1
execute if score @s mirror_taying_dx matches 0 if score @s mirror_taying_dz matches 1.. run particle minecraft:end_rod ~ ~0.1 ~ 0.2 0.02 0.2 0.005 1

# 7) 4 格（400）触发：3s buff + 8s 内置冷却，清零累计
scoreboard players set #taying_ready mirror_calc 0
execute if score @s mirror_taying_dist matches 400.. if score @s mirror_taying_cd matches 0 run scoreboard players set #taying_ready mirror_calc 1
execute if score #taying_ready mirror_calc matches 1 run scoreboard players set @s mirror_taying_buff 60
execute if score #taying_ready mirror_calc matches 1 run scoreboard players set @s mirror_taying_cd 160
execute if score #taying_ready mirror_calc matches 1 run scoreboard players set @s mirror_taying_dist 0

# 剑身白光 + 镜音（设计 §2.1.3）
execute if score #taying_ready mirror_calc matches 1 at @s run particle minecraft:end_rod ~ ~1 ~ 0.25 0.5 0.25 0.01 12
execute if score #taying_ready mirror_calc matches 1 at @s run playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 1 1.2
