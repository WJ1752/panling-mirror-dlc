# 洗统改名：按 #t wp_form / #t wp_mset 写 mirror_set + display.Name（槽 5）
execute if score #t wp_form matches 1 if score #t wp_mset matches 0 run function plm:weapon/table/name/1_0
execute if score #t wp_form matches 1 if score #t wp_mset matches 1 run function plm:weapon/table/name/1_1
execute if score #t wp_form matches 2 if score #t wp_mset matches 0 run function plm:weapon/table/name/2_0
execute if score #t wp_form matches 2 if score #t wp_mset matches 1 run function plm:weapon/table/name/2_1
execute if score #t wp_form matches 3 if score #t wp_mset matches 2 run function plm:weapon/table/name/3_2
execute if score #t wp_form matches 3 if score #t wp_mset matches 3 run function plm:weapon/table/name/3_3
execute if score #t wp_form matches 4 if score #t wp_mset matches 2 run function plm:weapon/table/name/4_2
execute if score #t wp_form matches 4 if score #t wp_mset matches 3 run function plm:weapon/table/name/4_3
execute if score #t wp_form matches 5 if score #t wp_mset matches 4 run function plm:weapon/table/name/5_4
execute if score #t wp_form matches 5 if score #t wp_mset matches 5 run function plm:weapon/table/name/5_5
execute if score #t wp_form matches 6 if score #t wp_mset matches 4 run function plm:weapon/table/name/6_4
execute if score #t wp_form matches 6 if score #t wp_mset matches 5 run function plm:weapon/table/name/6_5
