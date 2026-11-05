# SKL liu_ying_jiu（留影·久，max 40）— 已被残影弩消费
# parse 写入 wp_affix_skl_liu_ying_jiu = 实际值×10（0..400）。
# 消费点：plm:mirror/skill/crossbow/liuying/summon.mcfunction
#   弩机寿命 mirror_turret_5ticks = 32 + wp_affix_skl_liu_ying_jiu / 25
#   = 8s + 0..4s（400/25=16 个 5t = 4s）。
# 本文件不参与 parse（数值在技能函数内直接读 objective）。
