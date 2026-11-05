# 槽 0 倒影核：本器形五纹已满时淬纹；未满提示先开纹
# 锻位以实际数组为准，避免旧 mirror_temper 不同步导致满纹被误判为未满。
execute if score #t wp_core_kind matches 2 run function plm:weapon/affix/count
execute if score #t wp_core_kind matches 2 run scoreboard players operation #t wp_temper = #t wp_count
execute if score #t wp_core_kind matches 2 run function plm:weapon/table/full
execute if score #t wp_core_kind matches 2 if score #t wp_full matches 1 run function plm:weapon/table/quench
execute if score #t wp_core_kind matches 2 if score #t wp_full matches 0 run function plm:weapon/msg/not_full
execute if score #t wp_old_ver matches 1 run function plm:weapon/msg/old_ver
execute if score #t wp_core_kind matches 0 if score #t wp_old_ver matches 0 run function plm:weapon/msg/no_target
