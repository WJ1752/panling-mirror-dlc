# SKL jing_hua_tan（镜花·弹，max 40 → 满值 400，actual×10）
# 消费点：plm:mirror/skill/bow/route.mcfunction「镜花·弹」段。
#   wp_affix_skl_jing_hua_tan / 10 = 0..40（%），与 plm:weapon/util/rand100 的 1..100 比较；
#   命中则 mirror_bloom_count +1（额外绽放 1 个目标，用普通 60%+镜花·保强度）。
# 本文件不在调用路径上，只作为词条说明；具体读取在 route 里。
return 0
