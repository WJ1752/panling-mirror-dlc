# SKL liu_ying_su（留影·速，max 25）— 已被残影弩消费
# parse 写入 wp_affix_skl_liu_ying_su = 实际值×10（0..250）。
# 消费点：plm:mirror/skill/crossbow/liuying/summon.mcfunction
#   攻击间隔 mirror_turret_atk = 6 - wp_affix_skl_liu_ying_su / 100（最低 4 个 5t）；
#   词条余数 >=50 时，plm:mirror/skill/crossbow/liuying/fire.mcfunction 用 4/5 交替
#   （mirror_turret_count 作交替开关），对应设计「−25% -> 1.125s」。
# 本文件不参与 parse（数值在技能函数内直接读 objective）。
