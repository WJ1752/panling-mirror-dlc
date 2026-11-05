# 倒影核检查（槽 0）
execute if score #t wp_have0 >= #t wp_need_core run return 0
scoreboard players operation #t wp_diff = #t wp_need_core
scoreboard players operation #t wp_diff -= #t wp_have0
function plm:weapon/msg/need_core
scoreboard players set #t wp_abort 1
