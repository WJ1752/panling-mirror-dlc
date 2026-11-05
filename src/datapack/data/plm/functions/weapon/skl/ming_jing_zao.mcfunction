# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL ming_jing_zao（max 3）— 已被镜映消费。
# 实际消费点：plm:mirror/skill/parry/start.mcfunction:26-30
#   完美窗口 += wp_affix_skl_ming_jing_zao/25 个 5t（满值 +0.25s；设计 +0.3s，×10 取整后为 0.25s）。
# Phase 1 只 parse 出 wp_affix_skl_ming_jing_zao（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
