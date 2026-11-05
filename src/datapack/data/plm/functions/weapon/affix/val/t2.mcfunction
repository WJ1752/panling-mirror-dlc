# 品阶 2：区间 wp_tier_min2 .. min2+span2-1（独立均匀取偏移）
function plm:weapon/util/rand100
scoreboard players operation #t wp_val = #t wp_rand
scoreboard players operation #t wp_val %= #sys wp_tier_span2
scoreboard players operation #t wp_val += #sys wp_tier_min2
