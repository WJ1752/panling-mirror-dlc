# 镜片检查（槽 0）
execute if score #t wp_have0 >= #t wp_need_shard run return 0
scoreboard players operation #t wp_diff = #t wp_need_shard
scoreboard players operation #t wp_diff -= #t wp_have0
function plm:weapon/msg/need_shard
scoreboard players set #t wp_abort 1
