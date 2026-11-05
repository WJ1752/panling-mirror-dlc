# 影随 · 玩家侧 5t 判定（@s=斧玩家，at @s）
# 1) 取每玩家记分板环形缓冲的最近 2 个采样点（3s 内才有效）
# 2) 标记玩家 6 格内最近 12 只 tag=monster / tag=mirror_summon
# 3) 逐个交给 trail/check 做 1.5 格距离判定
# 坐标全部 ×100（1 = 0.01 格）；距离用平方和比较。

# ---- 影随词条：wp_affix_skl_ying_sui_zhi（max 8，actual×10 → 40..80）----
scoreboard players set #axe_skl mirror_axe_skl 0
scoreboard players operation #axe_skl mirror_axe_skl = @s wp_affix_skl_ying_sui_zhi

# ---- 最近点 1：按 mirror_trail_i 读槽位 ----
scoreboard players set #axe_p1ok mirror_axe_p1ok 0
scoreboard players set #axe_t1 mirror_wtmp 0
execute if score @s mirror_trail_i matches 1 run scoreboard players operation #axe_p1x mirror_axe_p1x = @s mirror_trail_x1
execute if score @s mirror_trail_i matches 1 run scoreboard players operation #axe_p1y mirror_axe_p1y = @s mirror_trail_y1
execute if score @s mirror_trail_i matches 1 run scoreboard players operation #axe_p1z mirror_axe_p1z = @s mirror_trail_z1
execute if score @s mirror_trail_i matches 1 run scoreboard players operation #axe_t1 mirror_wtmp = @s mirror_trail_t1
execute if score @s mirror_trail_i matches 2 run scoreboard players operation #axe_p1x mirror_axe_p1x = @s mirror_trail_x2
execute if score @s mirror_trail_i matches 2 run scoreboard players operation #axe_p1y mirror_axe_p1y = @s mirror_trail_y2
execute if score @s mirror_trail_i matches 2 run scoreboard players operation #axe_p1z mirror_axe_p1z = @s mirror_trail_z2
execute if score @s mirror_trail_i matches 2 run scoreboard players operation #axe_t1 mirror_wtmp = @s mirror_trail_t2
execute if score @s mirror_trail_i matches 3 run scoreboard players operation #axe_p1x mirror_axe_p1x = @s mirror_trail_x3
execute if score @s mirror_trail_i matches 3 run scoreboard players operation #axe_p1y mirror_axe_p1y = @s mirror_trail_y3
execute if score @s mirror_trail_i matches 3 run scoreboard players operation #axe_p1z mirror_axe_p1z = @s mirror_trail_z3
execute if score @s mirror_trail_i matches 3 run scoreboard players operation #axe_t1 mirror_wtmp = @s mirror_trail_t3
execute if score @s mirror_trail_i matches 4 run scoreboard players operation #axe_p1x mirror_axe_p1x = @s mirror_trail_x4
execute if score @s mirror_trail_i matches 4 run scoreboard players operation #axe_p1y mirror_axe_p1y = @s mirror_trail_y4
execute if score @s mirror_trail_i matches 4 run scoreboard players operation #axe_p1z mirror_axe_p1z = @s mirror_trail_z4
execute if score @s mirror_trail_i matches 4 run scoreboard players operation #axe_t1 mirror_wtmp = @s mirror_trail_t4
execute if score @s mirror_trail_i matches 5 run scoreboard players operation #axe_p1x mirror_axe_p1x = @s mirror_trail_x5
execute if score @s mirror_trail_i matches 5 run scoreboard players operation #axe_p1y mirror_axe_p1y = @s mirror_trail_y5
execute if score @s mirror_trail_i matches 5 run scoreboard players operation #axe_p1z mirror_axe_p1z = @s mirror_trail_z5
execute if score @s mirror_trail_i matches 5 run scoreboard players operation #axe_t1 mirror_wtmp = @s mirror_trail_t5
execute if score @s mirror_trail_i matches 6 run scoreboard players operation #axe_p1x mirror_axe_p1x = @s mirror_trail_x6
execute if score @s mirror_trail_i matches 6 run scoreboard players operation #axe_p1y mirror_axe_p1y = @s mirror_trail_y6
execute if score @s mirror_trail_i matches 6 run scoreboard players operation #axe_p1z mirror_axe_p1z = @s mirror_trail_z6
execute if score @s mirror_trail_i matches 6 run scoreboard players operation #axe_t1 mirror_wtmp = @s mirror_trail_t6
# t1 记录的是绝对 gametime；先换成 age
scoreboard players operation #axe_age mirror_wtmp2 = #sys mirror_game_time
scoreboard players operation #axe_age mirror_wtmp2 -= #axe_t1 mirror_wtmp

execute if score @s mirror_trail_i matches 1..6 if score @s mirror_trail_n matches 1.. if score #axe_age mirror_wtmp2 matches 0..60 run scoreboard players set #axe_p1ok mirror_axe_p1ok 1

# ---- 最近点 2：i-1，环形回绕到 6；不足 2 点或过期则无效 ----
scoreboard players set #axe_p2ok mirror_axe_p2ok 0
scoreboard players set #axe_t2 mirror_wtmp 0
scoreboard players operation #axe_prev mirror_wtmp3 = @s mirror_trail_i
scoreboard players remove #axe_prev mirror_wtmp3 1
execute if score #axe_prev mirror_wtmp3 matches 0 run scoreboard players set #axe_prev mirror_wtmp3 6
execute if score #axe_prev mirror_wtmp3 matches 1 run scoreboard players operation #axe_p2x mirror_axe_p2x = @s mirror_trail_x1
execute if score #axe_prev mirror_wtmp3 matches 1 run scoreboard players operation #axe_p2y mirror_axe_p2y = @s mirror_trail_y1
execute if score #axe_prev mirror_wtmp3 matches 1 run scoreboard players operation #axe_p2z mirror_axe_p2z = @s mirror_trail_z1
execute if score #axe_prev mirror_wtmp3 matches 1 run scoreboard players operation #axe_t2 mirror_wtmp = @s mirror_trail_t1
execute if score #axe_prev mirror_wtmp3 matches 2 run scoreboard players operation #axe_p2x mirror_axe_p2x = @s mirror_trail_x2
execute if score #axe_prev mirror_wtmp3 matches 2 run scoreboard players operation #axe_p2y mirror_axe_p2y = @s mirror_trail_y2
execute if score #axe_prev mirror_wtmp3 matches 2 run scoreboard players operation #axe_p2z mirror_axe_p2z = @s mirror_trail_z2
execute if score #axe_prev mirror_wtmp3 matches 2 run scoreboard players operation #axe_t2 mirror_wtmp = @s mirror_trail_t2
execute if score #axe_prev mirror_wtmp3 matches 3 run scoreboard players operation #axe_p2x mirror_axe_p2x = @s mirror_trail_x3
execute if score #axe_prev mirror_wtmp3 matches 3 run scoreboard players operation #axe_p2y mirror_axe_p2y = @s mirror_trail_y3
execute if score #axe_prev mirror_wtmp3 matches 3 run scoreboard players operation #axe_p2z mirror_axe_p2z = @s mirror_trail_z3
execute if score #axe_prev mirror_wtmp3 matches 3 run scoreboard players operation #axe_t2 mirror_wtmp = @s mirror_trail_t3
execute if score #axe_prev mirror_wtmp3 matches 4 run scoreboard players operation #axe_p2x mirror_axe_p2x = @s mirror_trail_x4
execute if score #axe_prev mirror_wtmp3 matches 4 run scoreboard players operation #axe_p2y mirror_axe_p2y = @s mirror_trail_y4
execute if score #axe_prev mirror_wtmp3 matches 4 run scoreboard players operation #axe_p2z mirror_axe_p2z = @s mirror_trail_z4
execute if score #axe_prev mirror_wtmp3 matches 4 run scoreboard players operation #axe_t2 mirror_wtmp = @s mirror_trail_t4
execute if score #axe_prev mirror_wtmp3 matches 5 run scoreboard players operation #axe_p2x mirror_axe_p2x = @s mirror_trail_x5
execute if score #axe_prev mirror_wtmp3 matches 5 run scoreboard players operation #axe_p2y mirror_axe_p2y = @s mirror_trail_y5
execute if score #axe_prev mirror_wtmp3 matches 5 run scoreboard players operation #axe_p2z mirror_axe_p2z = @s mirror_trail_z5
execute if score #axe_prev mirror_wtmp3 matches 5 run scoreboard players operation #axe_t2 mirror_wtmp = @s mirror_trail_t5
execute if score #axe_prev mirror_wtmp3 matches 6 run scoreboard players operation #axe_p2x mirror_axe_p2x = @s mirror_trail_x6
execute if score #axe_prev mirror_wtmp3 matches 6 run scoreboard players operation #axe_p2y mirror_axe_p2y = @s mirror_trail_y6
execute if score #axe_prev mirror_wtmp3 matches 6 run scoreboard players operation #axe_p2z mirror_axe_p2z = @s mirror_trail_z6
execute if score #axe_prev mirror_wtmp3 matches 6 run scoreboard players operation #axe_t2 mirror_wtmp = @s mirror_trail_t6
scoreboard players operation #axe_age2 mirror_wtmp2 = #sys mirror_game_time
scoreboard players operation #axe_age2 mirror_wtmp2 -= #axe_t2 mirror_wtmp
execute if score #axe_prev mirror_wtmp3 matches 1..6 if score @s mirror_trail_n matches 2.. if score #axe_age2 mirror_wtmp2 matches 0..60 run scoreboard players set #axe_p2ok mirror_axe_p2ok 1

# 两个点都无效 → 本玩家本 tick 无事可做
execute unless score #axe_p1ok mirror_axe_p1ok matches 1 unless score #axe_p2ok mirror_axe_p2ok matches 1 run return 0

# ---- 候选：6 格内最近 12 只（monster + mirror_summon 合流后取最近 12）----
execute at @s run tag @e[tag=monster,distance=..6,sort=nearest,limit=12] add mirror_axe_trail
execute at @s run tag @e[tag=mirror_summon,distance=..6,sort=nearest,limit=12] add mirror_axe_trail
execute at @s as @e[tag=mirror_axe_trail,limit=12,sort=nearest] run function plm:mirror/skill/axe/trail/check
tag @e[tag=mirror_axe_trail] remove mirror_axe_trail
