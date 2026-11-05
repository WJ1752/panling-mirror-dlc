# 洗练形状：A35 / B35 / C12 / D12 / E6（§5.1）
# 结果 → #t wp_shape 1..5，并写入 n_dmg / n_skl / n_fx
function plm:weapon/util/rand100
execute if score #t wp_rand <= #sys wp_shape_cut1 run function plm:weapon/affix/shape/1
execute if score #t wp_rand > #sys wp_shape_cut1 if score #t wp_rand <= #sys wp_shape_cut2 run function plm:weapon/affix/shape/2
execute if score #t wp_rand > #sys wp_shape_cut2 if score #t wp_rand <= #sys wp_shape_cut3 run function plm:weapon/affix/shape/3
execute if score #t wp_rand > #sys wp_shape_cut3 if score #t wp_rand <= #sys wp_shape_cut4 run function plm:weapon/affix/shape/4
execute if score #t wp_rand > #sys wp_shape_cut4 run function plm:weapon/affix/shape/5
