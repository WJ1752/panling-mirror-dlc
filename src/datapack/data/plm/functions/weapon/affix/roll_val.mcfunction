# 掷 val：先按 15/35/30/15/5 抽品阶，再在品阶区间内均匀取整数
# 结果 → #t wp_val（50..100）
function plm:weapon/util/rand100
execute if score #t wp_rand <= #sys wp_tier_cut1 run function plm:weapon/affix/val/t1
execute if score #t wp_rand > #sys wp_tier_cut1 if score #t wp_rand <= #sys wp_tier_cut2 run function plm:weapon/affix/val/t2
execute if score #t wp_rand > #sys wp_tier_cut2 if score #t wp_rand <= #sys wp_tier_cut3 run function plm:weapon/affix/val/t3
execute if score #t wp_rand > #sys wp_tier_cut3 if score #t wp_rand <= #sys wp_tier_cut4 run function plm:weapon/affix/val/t4
execute if score #t wp_rand > #sys wp_tier_cut4 run function plm:weapon/affix/val/t5
