# 品阶 3：区间 wp_tier_min3 .. min3+span3-1（独立均匀取偏移）
function plm:weapon/util/rand100
scoreboard players operation #t wp_val = #t wp_rand
scoreboard players operation #t wp_val %= #sys wp_tier_span3
scoreboard players operation #t wp_val += #sys wp_tier_min3
