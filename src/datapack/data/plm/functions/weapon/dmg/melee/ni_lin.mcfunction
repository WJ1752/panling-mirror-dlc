# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 逆鳞（ni_lin）— self
# 自身 hp_precent <40 时 +12%
execute unless score @s wp_affix_dmg_ni_lin matches 1.. run return 0
execute unless score @s hp_precent matches ..39 run return 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_dmg_ni_lin
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
scoreboard players operation #attack_damage_multiply_base int += #wp mirror_wtmp
