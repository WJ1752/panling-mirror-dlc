# 影尘检查：不足则 wp_diff=差额、发提示、abort=1
execute if score #t wp_have8 >= #t wp_need_dust run return 0
scoreboard players operation #t wp_diff = #t wp_need_dust
scoreboard players operation #t wp_diff -= #t wp_have8
function plm:weapon/msg/need_dust
scoreboard players set #t wp_abort 1
