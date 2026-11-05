# SKL ying_sui_duo（影随·多，max 40）— 已被残影弩消费
# parse 写入 wp_affix_skl_ying_sui_duo = 实际值×10（0..400）。
# 消费点：plm:mirror/skill/crossbow/yingsui/point.mcfunction
#   每个路径点额外的 1 支概率：rand100(1..100) ×10 <= wp_affix_skl_ying_sui_duo
#   -> 0..40%，且每点最多 +1 支（只再调用一次 yingsui/arrow）。
# 本文件不参与 parse（数值在技能函数内直接读 objective）。
