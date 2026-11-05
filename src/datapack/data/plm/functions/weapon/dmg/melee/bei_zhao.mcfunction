# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 背照（bei_zhao）— target
# 攻击者位于目标背后 120° 锥内 +15%（目标朝向为参考系，点积平方比较）
execute unless score @s wp_affix_dmg_bei_zhao matches 1.. run return 0
function plm:weapon/ctx/target_behind
execute unless score #wp mirror_wtmp10 matches 1 run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_bei_zhao
