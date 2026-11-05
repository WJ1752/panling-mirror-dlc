# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL ying_xin（max 25）— 已被镜映消费。
# 实际消费点：plm:mirror/skill/parry/hurt.mcfunction:33-40
#   反射比例 = 60（基础）/ 90（明镜）+ wp_affix_skl_ying_xin/10，上限 100。
# Phase 1 只 parse 出 wp_affix_skl_ying_xin（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
