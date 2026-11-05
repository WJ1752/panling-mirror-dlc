# 定向洗统第二枚镜缘
scoreboard players set #t wp_need 1
scoreboard players operation #t wp_left = #t wp_have1
scoreboard players operation #t wp_left -= #t wp_need
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_1
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:1b}]
