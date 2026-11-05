# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 输入：@s=玩家，@s mirror_ctx_extra=目标条件词条合计（百分点×10），
#       #temp player_cause_1damage=attack_damage1（×10，已含 multiply_base），
#       attack_multiplier（本体攻速/冷却倍率，100=满速），#attack_damage_multiply_base（百分点）。
# 设计 §6.1 要求「同类相加 1+Σ」：main hit 已含 (1+M)，追加部分只能按 base×P 计，
# 因此先除以 (100+M) 还原 base，再乘 P/1000，最后乘 cooldown 倍率 attack_multiplier/100。
# 输出：#temp entity_hurt_temp（2 位小数，100=1HP）。
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score #temp player_cause_1damage matches 1.. run return 0
execute unless score @s mirror_ctx_extra matches 1.. run return 0

# base = attack_damage1 * 100 / (100+M)；extra = base * P/1000 = attack_damage1*P/(100+M)
scoreboard players set #wp mirror_wtmp2 0
scoreboard players operation #wp mirror_wtmp2 = #const100 mirror_calc
scoreboard players operation #wp mirror_wtmp2 += #attack_damage_multiply_base int
execute if score #wp mirror_wtmp2 matches ..1 run scoreboard players set #wp mirror_wtmp2 1
scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage
scoreboard players operation #temp entity_hurt_temp *= @s mirror_ctx_extra
scoreboard players operation #temp entity_hurt_temp /= #wp mirror_wtmp2

# 与本体主伤害同样乘攻速/冷却倍率（get_multiplier：0/20/50/100）
scoreboard players operation #temp entity_hurt_temp *= attack_multiplier int
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
execute if score #temp entity_hurt_temp matches 1.. run function plm:weapon/dmg/extra_hit
