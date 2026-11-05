# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 连星（lian_xing）— self
# 每第 3 次命中 +20%；mirror_hit_seq 在 on_hit 递增
execute unless score @s wp_affix_dmg_lian_xing matches 1.. run return 0
execute unless score @s mirror_hit_seq matches 2 run return 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_dmg_lian_xing
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
scoreboard players operation #attack_damage_multiply_base int += #wp mirror_wtmp
