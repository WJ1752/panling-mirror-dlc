# 按 #t wp_idx + #t wp_form 追加一条 SKL（val 取 #t wp_val）
execute if score #t wp_idx matches 1 run function plm:weapon/affix/append/skl_1
execute if score #t wp_idx matches 2 run function plm:weapon/affix/append/skl_2
execute if score #t wp_idx matches 3 run function plm:weapon/affix/append/skl_3
execute if score #t wp_idx matches 4 run function plm:weapon/affix/append/skl_4
execute if score #t wp_idx matches 5 run function plm:weapon/affix/append/skl_5
execute if score #t wp_idx matches 6 run function plm:weapon/affix/append/skl_6
