# 砺镜砂检查（槽 1，仅开纹用）
execute if score #t wp_need_sand matches 0 run return 0
execute if score #t wp_sub_sand matches 1 if score #t wp_have1 >= #t wp_need_sand run return 0
scoreboard players operation #t wp_diff = #t wp_need_sand
execute if score #t wp_sub_sand matches 1 run scoreboard players operation #t wp_diff -= #t wp_have1
function plm:weapon/msg/need_sand
scoreboard players set #t wp_abort 1
