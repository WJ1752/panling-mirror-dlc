# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 数值由技能侧消费；本文件是生成器占位，不执行。

# SKL fen_ying_shi（max 15）— 已被分影消费。
# 实际消费点：plm:mirror/skill/shadow/start.mcfunction:29-38
#   倒影伤害比例 = 60 + wp_affix_skl_fen_ying_shi/10（60%..75%），明镜再 ×1.5。
# Phase 1 只 parse 出 wp_affix_skl_fen_ying_shi（actual×10）；本桩不被调用，return 0 是无操作入口。
return 0
