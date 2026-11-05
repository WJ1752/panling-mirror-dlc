# SKL zhao_yao_shen（照妖·深，max 80 → parse 后满值 800 = 8.00 个百分点）
# 消费点：
#   plm:mirror/skill/furnace/rub/release_route.mcfunction 预计算
#     #skill mirror_skill_tmp2 = 100 + 15 + wp_affix_skl_zhao_yao_shen/100（满值 800 → 123）
#   plm:mirror/skill/furnace/rub/release/zhao.mcfunction 对已显形目标乘 ×123/100
# 单位：pp×100，所以 /100（15% → 23%）
return 0
