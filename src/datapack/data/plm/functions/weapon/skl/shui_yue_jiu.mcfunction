# SKL shui_yue_jiu（水月·久，max 50 → 满值 500，actual×10）
# 消费点：plm:mirror/skill/bow/flower_add.mcfunction「到期时间」段。
#   mirror_flower_until = gametime + 300 + (wp_affix_skl_shui_yue_jiu × 20 / 100) ticks
#   （500 → +100 ticks = +5s）；到期在 route / resolve 触发点清零，不做全局 tick。
# 本文件不在调用路径上，只作为词条说明；具体读取在 flower_add 里。
return 0
