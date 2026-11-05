# 从槽 8/7/6/4/2 依次扣影尘；#t wp_dust8..wp_dust2 为扫描值，只扣真正装影尘的槽
execute if score #t wp_need_dust matches ..0 run return 0
execute if score #t wp_dust8 matches 1.. run function plm:weapon/table/take_dust/8
execute if score #t wp_need_dust matches ..0 run return 0
execute if score #t wp_dust7 matches 1.. run function plm:weapon/table/take_dust/7
execute if score #t wp_need_dust matches ..0 run return 0
execute if score #t wp_dust6 matches 1.. run function plm:weapon/table/take_dust/6
execute if score #t wp_need_dust matches ..0 run return 0
execute if score #t wp_dust4 matches 1.. run function plm:weapon/table/take_dust/4
execute if score #t wp_need_dust matches ..0 run return 0
execute if score #t wp_dust2 matches 1.. run function plm:weapon/table/take_dust/2
execute if score #t wp_need_dust matches ..0 run return 0
