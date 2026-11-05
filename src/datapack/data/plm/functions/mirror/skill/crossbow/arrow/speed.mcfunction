# 箭当前速度 ×100（@s=箭）
# 读 Motion[0..2]（格/t）×100，取绝对值，整数 Newton 求 sqrt(dx²+dy²+dz²)。
# 结果 #speed100 mirror_wtmp11，封顶 300（技能箭初速固定 3.0）。
execute store result score #sp mirror_wtmp4 run data get entity @s Motion[0] 100
execute store result score #sp mirror_wtmp5 run data get entity @s Motion[1] 100
execute store result score #sp mirror_wtmp6 run data get entity @s Motion[2] 100
scoreboard players set #sp mirror_wtmp10 -1
execute if score #sp mirror_wtmp4 matches ..-1 run scoreboard players operation #sp mirror_wtmp4 *= #sp mirror_wtmp10
execute if score #sp mirror_wtmp5 matches ..-1 run scoreboard players operation #sp mirror_wtmp5 *= #sp mirror_wtmp10
execute if score #sp mirror_wtmp6 matches ..-1 run scoreboard players operation #sp mirror_wtmp6 *= #sp mirror_wtmp10

# 初值 = max(|vx|,|vy|,|vz|)，至少 1
scoreboard players operation #sp mirror_wtmp12 = #sp mirror_wtmp4
execute if score #sp mirror_wtmp5 > #sp mirror_wtmp12 run scoreboard players operation #sp mirror_wtmp12 = #sp mirror_wtmp5
execute if score #sp mirror_wtmp6 > #sp mirror_wtmp12 run scoreboard players operation #sp mirror_wtmp12 = #sp mirror_wtmp6
execute if score #sp mirror_wtmp12 matches ..0 run scoreboard players set #sp mirror_wtmp12 1

# n2 = dx²+dy²+dz²
scoreboard players operation #sp mirror_wtmp7 = #sp mirror_wtmp4
scoreboard players operation #sp mirror_wtmp7 *= #sp mirror_wtmp4
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp5
scoreboard players operation #sp mirror_wtmp8 *= #sp mirror_wtmp5
scoreboard players operation #sp mirror_wtmp7 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp6
scoreboard players operation #sp mirror_wtmp8 *= #sp mirror_wtmp6
scoreboard players operation #sp mirror_wtmp7 += #sp mirror_wtmp8
execute if score #sp mirror_wtmp7 matches ..0 run scoreboard players set #speed100 mirror_wtmp11 0
execute if score #sp mirror_wtmp7 matches ..0 run return 0

scoreboard players operation #sp mirror_wtmp9 = #sp mirror_wtmp12
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp7
scoreboard players operation #sp mirror_wtmp8 /= #sp mirror_wtmp9
scoreboard players operation #sp mirror_wtmp9 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp9 /= #const2 mirror_calc
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp7
scoreboard players operation #sp mirror_wtmp8 /= #sp mirror_wtmp9
scoreboard players operation #sp mirror_wtmp9 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp9 /= #const2 mirror_calc
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp7
scoreboard players operation #sp mirror_wtmp8 /= #sp mirror_wtmp9
scoreboard players operation #sp mirror_wtmp9 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp9 /= #const2 mirror_calc
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp7
scoreboard players operation #sp mirror_wtmp8 /= #sp mirror_wtmp9
scoreboard players operation #sp mirror_wtmp9 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp9 /= #const2 mirror_calc
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp7
scoreboard players operation #sp mirror_wtmp8 /= #sp mirror_wtmp9
scoreboard players operation #sp mirror_wtmp9 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp9 /= #const2 mirror_calc
scoreboard players operation #sp mirror_wtmp8 = #sp mirror_wtmp7
scoreboard players operation #sp mirror_wtmp8 /= #sp mirror_wtmp9
scoreboard players operation #sp mirror_wtmp9 += #sp mirror_wtmp8
scoreboard players operation #sp mirror_wtmp9 /= #const2 mirror_calc

scoreboard players operation #speed100 mirror_wtmp11 = #sp mirror_wtmp9
execute if score #sp mirror_wtmp7 matches ..0 run scoreboard players set #speed100 mirror_wtmp11 0
execute if score #speed100 mirror_wtmp11 matches 301.. run scoreboard players set #speed100 mirror_wtmp11 300
execute if score #speed100 mirror_wtmp11 matches ..-1 run scoreboard players set #speed100 mirror_wtmp11 0
