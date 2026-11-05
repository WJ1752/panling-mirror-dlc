# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 裂影基底：造成伤害时 5% 概率追加一次 10% 影伤。
# 只给剑/斧（mirror_set=1 裂影；mirror_form 0/1）。与五纹追加伤害合并为一次。
execute unless score @s wp_set matches 1 run return 0
execute unless score @s mirror_form matches 0..1 run return 0
execute if predicate plm:chance/5 run scoreboard players add @s mirror_ctx_extra 100
