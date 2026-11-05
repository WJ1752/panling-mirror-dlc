# 品阶 1：区间 wp_tier_min1 .. min1+span1-1（独立均匀取偏移）
function plm:weapon/util/rand100
scoreboard players operation #t wp_val = #t wp_rand
scoreboard players operation #t wp_val %= #sys wp_tier_span1
scoreboard players operation #t wp_val += #sys wp_tier_min1
