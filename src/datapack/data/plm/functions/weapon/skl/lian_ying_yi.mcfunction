# SKL lian_ying_yi（连影·易，max 50）— 已被残影弩消费
# parse 写入 wp_affix_skl_lian_ying_yi = 实际值×10（0..500）。
# 消费点：plm:mirror/skill/crossbow/lian/power.mcfunction
#   重影箭命中后保留连击计数（mirror_lian=3）的概率：
#   rand100(1..100) ×10 <= wp_affix_skl_lian_ying_yi -> 0..50%。
# 本文件不参与 parse（数值在技能函数内直接读 objective）。
