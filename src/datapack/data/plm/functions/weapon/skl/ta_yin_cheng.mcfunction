# SKL ta_yin_cheng（拓印·固，max 15 → parse 后满值 150 = 15.0%）
# 消费点：plm:mirror/skill/furnace/rub/bonus.mcfunction
#   每次加印（击杀/本体阵法）后 roll 0..99，`#rub mirror_rub_cd < wp_affix_skl_ta_yin_cheng/10` → 再 +1 印
# 单位：wp_affix_skl_ta_yin_cheng 是实际百分点×10，所以阈值 = /10（150 → 15%）
# 本文件不被任何函数调用；词条在 parse 阶段写成 objective，技能函数直接读。
return 0
