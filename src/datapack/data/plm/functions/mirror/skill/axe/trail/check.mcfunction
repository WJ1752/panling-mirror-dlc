# 影随 · 单个敌人判定（@s=敌人）
# 前置：#axe_p1*/#axe_p2* 已由 trail/tick_player 写入（坐标 ×100，*ok=1 表示有效）。
# 落在任意一个有效采样点 1.5 格内（平方距离 ≤ 22500）→ trail/slow。
scoreboard players set #axe_hit mirror_skill_tmp 0
scoreboard players set #axe_d2 mirror_skill_tmp 2147483647

# ---- 点 1 ----
execute if score #axe_p1ok mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qx mirror_skill_tmp = #axe_p1x mirror_axe_p1x
execute if score #axe_p1ok mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qy mirror_skill_tmp = #axe_p1y mirror_axe_p1y
execute if score #axe_p1ok mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qz mirror_skill_tmp = #axe_p1z mirror_axe_p1z
execute if score #axe_p1ok mirror_axe_p1ok matches 1 run function plm:mirror/skill/axe/trail/distance
execute if score #axe_p1ok mirror_axe_p1ok matches 1 if score #axe_d2 mirror_skill_tmp matches ..22500 run scoreboard players set #axe_hit mirror_skill_tmp 1

# ---- 点 2（点 1 未命中才判定）----
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p2ok mirror_axe_p2ok matches 1 run scoreboard players operation #axe_qx mirror_skill_tmp = #axe_p2x mirror_axe_p2x
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p2ok mirror_axe_p2ok matches 1 run scoreboard players operation #axe_qy mirror_skill_tmp = #axe_p2y mirror_axe_p2y
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p2ok mirror_axe_p2ok matches 1 run scoreboard players operation #axe_qz mirror_skill_tmp = #axe_p2z mirror_axe_p2z
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p2ok mirror_axe_p2ok matches 1 run scoreboard players set #axe_d2 mirror_skill_tmp 2147483647
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p2ok mirror_axe_p2ok matches 1 run function plm:mirror/skill/axe/trail/distance
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p2ok mirror_axe_p2ok matches 1 if score #axe_d2 mirror_skill_tmp matches ..22500 run scoreboard players set #axe_hit mirror_skill_tmp 1

# ---- 中点（最近两点的中点）----
# 采样每 10t 一次，步行约 2.16 格/采样；只判定两个端点时，目标在 1.5 格带边缘
# （横向 1 格 + 沿路 1.08 格 ≈ 1.47）几乎没有余量，相位稍偏就漏判。
# 再判一次两点的中点，等效于把离散点连成线段，1.5 格半径才真正覆盖整条影迹。
scoreboard players set #axe_mid mirror_axe_p1ok 0
execute if score #axe_hit mirror_skill_tmp matches 0 if score #axe_p1ok mirror_axe_p1ok matches 1 if score #axe_p2ok mirror_axe_p2ok matches 1 run scoreboard players set #axe_mid mirror_axe_p1ok 1
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qx mirror_skill_tmp = #axe_p1x mirror_axe_p1x
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qx mirror_skill_tmp += #axe_p2x mirror_axe_p2x
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qx mirror_skill_tmp /= #const2 mirror_calc
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qy mirror_skill_tmp = #axe_p1y mirror_axe_p1y
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qy mirror_skill_tmp += #axe_p2y mirror_axe_p2y
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qy mirror_skill_tmp /= #const2 mirror_calc
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qz mirror_skill_tmp = #axe_p1z mirror_axe_p1z
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qz mirror_skill_tmp += #axe_p2z mirror_axe_p2z
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players operation #axe_qz mirror_skill_tmp /= #const2 mirror_calc
execute if score #axe_mid mirror_axe_p1ok matches 1 run scoreboard players set #axe_d2 mirror_skill_tmp 2147483647
execute if score #axe_mid mirror_axe_p1ok matches 1 run function plm:mirror/skill/axe/trail/distance
execute if score #axe_mid mirror_axe_p1ok matches 1 if score #axe_d2 mirror_skill_tmp matches ..22500 run scoreboard players set #axe_hit mirror_skill_tmp 1

execute if score #axe_hit mirror_skill_tmp matches 1 run function plm:mirror/skill/axe/trail/slow
