# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# SKL ying_sui_zhi（max 8）— 由裂影斧被动「影随」消费，本桩不结算。
# 由 plm:mirror/skill/axe/tick（经 trail/tick_player）读取 wp_affix_skl_ying_sui_zhi；
# 实际值 = max 8 × val / 10（actual×10，满值 80），即额外 0..8pp。
# 消费点：plm:mirror/skill/axe/trail/slow —— 基础 15% 用 slowness I；
#         额外 8pp 用 generic.movement_speed 的固定 UUID 临时 modifier（−0.04..−0.08，multiply）。
# 本桩保留 return 0，不在这里假装结算。
return 0
