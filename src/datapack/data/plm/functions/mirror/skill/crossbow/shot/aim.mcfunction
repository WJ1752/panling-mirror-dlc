# 通用：把 mirror_shot_new 这支箭朝 mirror_dmg_target 射出去，并写入 damage。
# 调用前：
#   #cbpx/#cbpy/#cbpz (mirror_wtmp / mirror_wtmp2 / mirror_wtmp3) = 发射点 ×100（py 已含箭生成高度）
#   #cbdmg (mirror_wtmp12) = 箭 damage NBT ×10
# 箭必须已带 mirror_shot_new；本函数不改 @s，只用 tag 选箭。
# 1.20.1 箭最终伤害 = ceil(速度 × damage NBT)（实测：速度 3.0 × 1.0 = 3 点）。
# 因此统一用 3.0 格/t 的初速，damage NBT 按“主人箭矢强度/10 × 百分比”写。
execute store result score #cbtx mirror_wtmp11 run data get entity @e[tag=mirror_dmg_target,limit=1] Pos[0] 100
execute store result score #cbty mirror_skill_tmp2 run data get entity @e[tag=mirror_dmg_target,limit=1] Pos[1] 100
scoreboard players add #cbty mirror_skill_tmp2 100
execute store result score #cbtz mirror_skill_tmp3 run data get entity @e[tag=mirror_dmg_target,limit=1] Pos[2] 100

scoreboard players operation #cbdx mirror_wtmp4 = #cbtx mirror_wtmp11
scoreboard players operation #cbdx mirror_wtmp4 -= #cbpx mirror_wtmp
scoreboard players operation #cbdy mirror_wtmp5 = #cbty mirror_skill_tmp2
scoreboard players operation #cbdy mirror_wtmp5 -= #cbpy mirror_wtmp2
scoreboard players operation #cbdz mirror_wtmp6 = #cbtz mirror_skill_tmp3
scoreboard players operation #cbdz mirror_wtmp6 -= #cbpz mirror_wtmp3

# max(|dx|, |dy|, |dz|)，最少 100（1 格），防止除 0
scoreboard players set #cbm1 mirror_wtmp10 -1
scoreboard players operation #cbax mirror_wtmp8 = #cbdx mirror_wtmp4
execute if score #cbax mirror_wtmp8 matches ..-1 run scoreboard players operation #cbax mirror_wtmp8 *= #cbm1 mirror_wtmp10
scoreboard players operation #cbaz mirror_wtmp9 = #cbdz mirror_wtmp6
execute if score #cbaz mirror_wtmp9 matches ..-1 run scoreboard players operation #cbaz mirror_wtmp9 *= #cbm1 mirror_wtmp10
scoreboard players operation #cbay mirror_skill_tmp = #cbdy mirror_wtmp5
execute if score #cbay mirror_skill_tmp matches ..-1 run scoreboard players operation #cbay mirror_skill_tmp *= #cbm1 mirror_wtmp10
scoreboard players operation #cbmax mirror_wtmp7 = #cbax mirror_wtmp8
execute if score #cbay mirror_skill_tmp > #cbmax mirror_wtmp7 run scoreboard players operation #cbmax mirror_wtmp7 = #cbay mirror_skill_tmp
execute if score #cbaz mirror_wtmp9 > #cbmax mirror_wtmp7 run scoreboard players operation #cbmax mirror_wtmp7 = #cbaz mirror_wtmp9
execute if score #cbmax mirror_wtmp7 matches ..99 run scoreboard players set #cbmax mirror_wtmp7 100

# 归一化到固定矢量长度 3.0 格/t，而不是“最大轴 = 3.0”。
# 旧实现斜射时矢量长度可达 3√2≈4.24（+41%）甚至 3√3≈5.20（+73%），
# 导致齐射/弩机伤害随方向变化。这里用整数 Newton 迭代求 sqrt(dx²+dy²+dz²)。
scoreboard players operation #cb_n2 mirror_skill_tmp = #cbdx mirror_wtmp4
scoreboard players operation #cb_n2 mirror_skill_tmp *= #cbdx mirror_wtmp4
scoreboard players operation #cbterm mirror_wtmp8 = #cbdy mirror_wtmp5
scoreboard players operation #cbterm mirror_wtmp8 *= #cbdy mirror_wtmp5
scoreboard players operation #cb_n2 mirror_skill_tmp += #cbterm mirror_wtmp8
scoreboard players operation #cbterm mirror_wtmp8 = #cbdz mirror_wtmp6
scoreboard players operation #cbterm mirror_wtmp8 *= #cbdz mirror_wtmp6
scoreboard players operation #cb_n2 mirror_skill_tmp += #cbterm mirror_wtmp8
execute if score #cb_n2 mirror_skill_tmp matches ..0 run scoreboard players set #cb_n2 mirror_skill_tmp 1

# Newton: x_{n+1} = (x_n + N/x_n) / 2，6 次足够（N ≤ 约 270000）
scoreboard players operation #cb_sq mirror_skill_tmp2 = #cbmax mirror_wtmp7
scoreboard players operation #cb_q mirror_skill_tmp3 = #cb_n2 mirror_skill_tmp
scoreboard players operation #cb_q mirror_skill_tmp3 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cb_sq mirror_skill_tmp2 += #cb_q mirror_skill_tmp3
scoreboard players operation #cb_sq mirror_skill_tmp2 /= #const2 mirror_calc
scoreboard players operation #cb_q mirror_skill_tmp3 = #cb_n2 mirror_skill_tmp
scoreboard players operation #cb_q mirror_skill_tmp3 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cb_sq mirror_skill_tmp2 += #cb_q mirror_skill_tmp3
scoreboard players operation #cb_sq mirror_skill_tmp2 /= #const2 mirror_calc
scoreboard players operation #cb_q mirror_skill_tmp3 = #cb_n2 mirror_skill_tmp
scoreboard players operation #cb_q mirror_skill_tmp3 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cb_sq mirror_skill_tmp2 += #cb_q mirror_skill_tmp3
scoreboard players operation #cb_sq mirror_skill_tmp2 /= #const2 mirror_calc
scoreboard players operation #cb_q mirror_skill_tmp3 = #cb_n2 mirror_skill_tmp
scoreboard players operation #cb_q mirror_skill_tmp3 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cb_sq mirror_skill_tmp2 += #cb_q mirror_skill_tmp3
scoreboard players operation #cb_sq mirror_skill_tmp2 /= #const2 mirror_calc
scoreboard players operation #cb_q mirror_skill_tmp3 = #cb_n2 mirror_skill_tmp
scoreboard players operation #cb_q mirror_skill_tmp3 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cb_sq mirror_skill_tmp2 += #cb_q mirror_skill_tmp3
scoreboard players operation #cb_sq mirror_skill_tmp2 /= #const2 mirror_calc
scoreboard players operation #cb_q mirror_skill_tmp3 = #cb_n2 mirror_skill_tmp
scoreboard players operation #cb_q mirror_skill_tmp3 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cb_sq mirror_skill_tmp2 += #cb_q mirror_skill_tmp3
scoreboard players operation #cb_sq mirror_skill_tmp2 /= #const2 mirror_calc

# v = d × 300 / |d|（单位：0.01 格/t -> 矢量长度 3.0 格/t）
scoreboard players operation #cbdx mirror_wtmp4 *= #const3 mirror_calc
scoreboard players operation #cbdx mirror_wtmp4 *= #const100 mirror_calc
scoreboard players operation #cbdx mirror_wtmp4 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cbdy mirror_wtmp5 *= #const3 mirror_calc
scoreboard players operation #cbdy mirror_wtmp5 *= #const100 mirror_calc
scoreboard players operation #cbdy mirror_wtmp5 /= #cb_sq mirror_skill_tmp2
scoreboard players operation #cbdz mirror_wtmp6 *= #const3 mirror_calc
scoreboard players operation #cbdz mirror_wtmp6 *= #const100 mirror_calc
scoreboard players operation #cbdz mirror_wtmp6 /= #cb_sq mirror_skill_tmp2

execute store result entity @e[tag=mirror_shot_new,limit=1] Motion[0] double 0.01 run scoreboard players get #cbdx mirror_wtmp4
execute store result entity @e[tag=mirror_shot_new,limit=1] Motion[1] double 0.01 run scoreboard players get #cbdy mirror_wtmp5
execute store result entity @e[tag=mirror_shot_new,limit=1] Motion[2] double 0.01 run scoreboard players get #cbdz mirror_wtmp6
# PvP 收尾（设计 §1.6）：弩机/齐射箭只做视觉，真实箭 damage=0；
# 实际伤害由 plm:mirror/skill/crossbow/arrow/hit_check 对 monster/mirror_boss/mirror_summon 直接结算。
# mirror_dmg = 0.1 HP 定点的箭基伤，供直接结算按命中时速度还原衰减。
data modify entity @e[tag=mirror_shot_new,limit=1] damage set value 0.0d
execute store result entity @e[tag=mirror_shot_new,limit=1] mirror_dmg int 1 run scoreboard players get #cbdmg mirror_wtmp12
