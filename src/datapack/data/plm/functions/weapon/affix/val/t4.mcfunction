# 品阶 4：区间 wp_tier_min4 .. min4+span4-1（独立均匀取偏移）
function plm:weapon/util/rand100
scoreboard players operation #t wp_val = #t wp_rand
scoreboard players operation #t wp_val %= #sys wp_tier_span4
scoreboard players operation #t wp_val += #sys wp_tier_min4
