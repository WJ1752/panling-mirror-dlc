# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL fen_ying_ji（max 25）— 已被分影消费。
# 实际消费点：plm:mirror/skill/shadow/start.mcfunction:42-50
#   倒影攻击间隔 = 6 - wp_affix_skl_fen_ying_ji/100 个 5t，最低 4（1.0s）。
# Phase 1 只 parse 出 wp_affix_skl_fen_ying_ji（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
