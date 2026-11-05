# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL chi_jing（max 15）— 已被镜映消费。
# 实际消费点：plm:mirror/skill/parry/start.mcfunction:22-26
#   架势时长 += wp_affix_skl_chi_jing/25 个 5t（满值 +1.5s）。
# Phase 1 只 parse 出 wp_affix_skl_chi_jing（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
