# 影随 · 5s 到期齐射（@s=玩家，at @s）
# 设计 §2.4.2：路径最多 10 点，按 2 格取点（最多 8 个），每点独立找 8 格内最近敌人射 1 支；
# 伤害 = archer_damage_should × (30 + 影随·强/10)%；影随·多每点 40% 额外 +1（最多 +1）。
execute unless score @s mirror_path_n matches 1.. run return 0
scoreboard players set @s mirror_yingsui_fired 0

# 4 件套：齐射后 5s 内装填 +50%（临时 Quick Charge III；由 set/can/tick 还原）
execute at @s run function plm:mirror/set/can/crossbow_buff
# 记录原始点数；step 会递增 mirror_path_i，不能再用 mirror_path_n 当已取点数
scoreboard players operation #ys_n mirror_path_ysn = @s mirror_path_n
scoreboard players set @s mirror_path_i 0
scoreboard players set @s mirror_path_taken 0

# 每支箭的 damage NBT×10 = archer_damage_should × pct / 100
scoreboard players set #pct mirror_skill_tmp 30
scoreboard players set #add mirror_skill_tmp2 0
scoreboard players operation #add mirror_skill_tmp2 = @s wp_affix_skl_ying_sui_qiang
scoreboard players operation #add mirror_skill_tmp2 /= #const10 mirror_calc
scoreboard players operation #pct mirror_skill_tmp += #add mirror_skill_tmp2
scoreboard players set #cbdmg mirror_wtmp12 0
scoreboard players operation #cbdmg mirror_wtmp12 = @s archer_damage_should
scoreboard players operation #cbdmg mirror_wtmp12 *= #pct mirror_skill_tmp
scoreboard players operation #cbdmg mirror_wtmp12 /= #const100 mirror_calc

execute at @s run playsound minecraft:item.crossbow.quick_charge_3 master @a ~ ~ ~ 1 1
execute at @s run particle minecraft:dust 0.55 0.25 0.95 1.0 ~ ~1 ~ 0.5 0.8 0.5 0 20

# 10 个记录点，最多取 8 个（每 2 格）
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step
function plm:mirror/skill/crossbow/yingsui/step

# 结束本次记录：清空玩家自己的路径槽位
tag @s remove mirror_yingsui_rec
scoreboard players set @s mirror_path_n 0
scoreboard players set @s mirror_path_i 0
scoreboard players set @s mirror_path_t 0
scoreboard players set @s mirror_path_taken 0
scoreboard players set @s mirror_path_dim 0
