# 开纹扣砺镜砂（槽 1，按 need_sand）
scoreboard players operation #t wp_left = #t wp_have1
scoreboard players operation #t wp_left -= #t wp_need_sand
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_1
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:1b}]
