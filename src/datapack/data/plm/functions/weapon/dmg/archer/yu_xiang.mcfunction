# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 余响（yu_xiang）— 弓/弩自状态词条
# 击杀后 3s（60 tick）内 +10%
execute unless score @s wp_affix_dmg_yu_xiang matches 1.. run return 0
execute unless score @s mirror_last_kill matches 1.. run return 0
scoreboard players operation #wp mirror_wtmp2 = #sys mirror_game_time
scoreboard players operation #wp mirror_wtmp2 -= @s mirror_last_kill
execute unless score #wp mirror_wtmp2 matches 0..60 run return 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_dmg_yu_xiang
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
scoreboard players operation @s archer_damage_l6 += #wp mirror_wtmp
