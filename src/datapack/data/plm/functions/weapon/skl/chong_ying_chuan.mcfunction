# SKL chong_ying_chuan（重影·穿，max 20）— 已被残影弩消费
# parse 写入 wp_affix_skl_chong_ying_chuan = 实际值×10（0..200）。
# 消费点：plm:mirror/skill/crossbow/lian/power.mcfunction
#   重影箭额外穿透 PierceLevel 增量 = 2 + wp_affix_skl_chong_ying_chuan / 100
#   （+2 -> +4），叠加命中箭原有 PierceLevel。
# 本文件不参与 parse（数值在技能函数内直接读 objective）。
