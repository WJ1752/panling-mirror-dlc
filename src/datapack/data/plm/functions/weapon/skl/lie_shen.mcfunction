# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL lie_shen（max 25）— 已被裂痕引爆消费。
# 实际消费点：plm:weapon/axe/lie/explode.mcfunction:9-15
#   引爆比例 pct = 80 + wp_affix_skl_lie_shen×8/100（8.0%..10.0%，0.1% 定点）。
# Phase 1 只 parse 出 wp_affix_skl_lie_shen（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
