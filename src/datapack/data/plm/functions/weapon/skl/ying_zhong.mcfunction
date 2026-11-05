# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL ying_zhong（max 12）— 已被重影起手消费。
# 实际消费点：plm:mirror/skill/axe/chongying/start.mcfunction:22-26
#   影伤比例 += wp_affix_skl_ying_zhong/4（90=9% → 满值 +3pp，12%）。
# Phase 1 只 parse 出 wp_affix_skl_ying_zhong（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
