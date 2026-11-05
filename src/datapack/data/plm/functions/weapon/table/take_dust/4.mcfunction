# 从槽 4 扣影尘（#t wp_dust4 为扫描值）
scoreboard players operation #t wp_left = #t wp_dust4
scoreboard players operation #t wp_left -= #t wp_need_dust
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_4
execute if score #t wp_left matches 1.. run scoreboard players set #t wp_need_dust 0
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:4b}]
execute if score #t wp_left matches ..0 run scoreboard players operation #t wp_need_dust -= #t wp_dust4
