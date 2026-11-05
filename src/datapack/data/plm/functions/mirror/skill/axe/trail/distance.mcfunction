# 影随 · 平方距离（@s=敌人；#axe_qx/qy/qz=采样点坐标 ×100）
# 输出 #axe_d2 = dx²+dy²+dz²（单位 0.01 格；1.5 格 = 150 → 22500）
execute store result score #axe_ex mirror_skill_tmp run data get entity @s Pos[0] 100
execute store result score #axe_ey mirror_skill_tmp run data get entity @s Pos[1] 100
execute store result score #axe_ez mirror_skill_tmp run data get entity @s Pos[2] 100

scoreboard players operation #axe_dx mirror_skill_tmp = #axe_ex mirror_skill_tmp
scoreboard players operation #axe_dx mirror_skill_tmp -= #axe_qx mirror_skill_tmp
scoreboard players operation #axe_dx mirror_skill_tmp *= #axe_dx mirror_skill_tmp
scoreboard players operation #axe_dy mirror_skill_tmp = #axe_ey mirror_skill_tmp
scoreboard players operation #axe_dy mirror_skill_tmp -= #axe_qy mirror_skill_tmp
scoreboard players operation #axe_dy mirror_skill_tmp *= #axe_dy mirror_skill_tmp
scoreboard players operation #axe_dz mirror_skill_tmp = #axe_ez mirror_skill_tmp
scoreboard players operation #axe_dz mirror_skill_tmp -= #axe_qz mirror_skill_tmp
scoreboard players operation #axe_dz mirror_skill_tmp *= #axe_dz mirror_skill_tmp

scoreboard players operation #axe_d2 mirror_skill_tmp = #axe_dx mirror_skill_tmp
scoreboard players operation #axe_d2 mirror_skill_tmp += #axe_dy mirror_skill_tmp
scoreboard players operation #axe_d2 mirror_skill_tmp += #axe_dz mirror_skill_tmp
