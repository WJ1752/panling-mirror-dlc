# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 破晓（po_xiao）— target
# 目标生命 >=90% 时 +15%（ctx 在 multiply_base 内、伤害结算前读目标 HP）
execute unless score @s wp_affix_dmg_po_xiao matches 1.. run return 0
function plm:weapon/ctx/target_hp
execute unless score #wp mirror_wtmp matches 90.. run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_po_xiao
