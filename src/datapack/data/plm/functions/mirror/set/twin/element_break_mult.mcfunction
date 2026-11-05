# 相克：把目标的有效元素抗性从 N 级降到 N-1 级
# @s = 目标；修改 #tw_dmg mirror_skill_tmp2（100 = 1 HP 定点）。
# 原版 Resistance（Id:11，每级 -20%，封顶 5 级）仍由 public_damage_entity 正常结算；
# 这里在进入公共管线前乘 (100-20*(N-1))/(100-20*N)，让最终等效为 N-1 级。
# N=5 时公共管线会把伤害乘 0，无法用预乘救回（1.20.1 不可靠实现）——跳过并在报告写 blocker。
scoreboard players set #tw_res mirror_zf_tmp 0
execute if data entity @s ActiveEffects[{Id:11}] store result score #tw_res mirror_zf_tmp run data get entity @s ActiveEffects[{Id:11}].Amplifier
execute if data entity @s ActiveEffects[{Id:11}] run scoreboard players add #tw_res mirror_zf_tmp 1
execute unless score #tw_res mirror_zf_tmp matches 1..4 run return 0

# tmp = 20*N（用 #const10 × #const2 拼 20，不新增常量）
scoreboard players operation #tw_brk mirror_zf_tmp2 = #tw_res mirror_zf_tmp
scoreboard players operation #tw_brk mirror_zf_tmp2 *= #const10 mirror_calc
scoreboard players operation #tw_brk mirror_zf_tmp2 *= #const2 mirror_calc
# num = 120 - 20N（等效 N-1 级的减伤后倍率）
scoreboard players set #tw_num mirror_zf_tmp3 120
scoreboard players operation #tw_num mirror_zf_tmp3 -= #tw_brk mirror_zf_tmp2
# den = 100 - 20N（public_damage_entity 会乘的当前倍率）
scoreboard players set #tw_den mirror_skill_tmp 100
scoreboard players operation #tw_den mirror_skill_tmp -= #tw_brk mirror_zf_tmp2
execute if score #tw_den mirror_skill_tmp matches 1.. run scoreboard players operation #tw_dmg mirror_skill_tmp2 *= #tw_num mirror_zf_tmp3
execute if score #tw_den mirror_skill_tmp matches 1.. run scoreboard players operation #tw_dmg mirror_skill_tmp2 /= #tw_den mirror_skill_tmp
