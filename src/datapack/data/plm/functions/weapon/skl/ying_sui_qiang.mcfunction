# SKL ying_sui_qiang（影随·强，max 8）— 已被残影弩消费
# parse 写入 wp_affix_skl_ying_sui_qiang = 实际值×10（0..80）。
# 消费点：plm:mirror/skill/crossbow/yingsui/fire.mcfunction
#   齐射强度 pct = 30 + wp_affix_skl_ying_sui_qiang / 10（30% -> 38%）；
#   箭 damage NBT×10 = archer_damage_should × pct / 100。
# 本文件不参与 parse（数值在技能函数内直接读 objective）。
