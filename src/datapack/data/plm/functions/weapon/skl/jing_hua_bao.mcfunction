# SKL jing_hua_bao（镜花·保，max 8 → 满值 80，actual×10）
# 消费点：plm:mirror/skill/bow/route.mcfunction「普通绽放」段。
#   mirror_bloom_target = 60 + wp_affix_skl_jing_hua_bao / 10（60 → 68%）。
#   该值随箭快照（tag_arrow），命中时由 slot1/2/4 使用；花影满的第 3 槽用 mirror_bloom_pct，不吃本词条。
# 本文件不在调用路径上，只作为词条说明；具体读取在 route 里。
return 0
