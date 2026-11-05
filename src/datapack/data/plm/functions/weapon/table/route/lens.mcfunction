# 槽 0 镜片：槽 3 镜胚=合成；槽 3 镜武未满五纹上限=开纹；已满=提示
execute if score #t wp_core_kind matches 1 if score #t wp_form matches 1..6 run function plm:weapon/table/craft
# 锻位以实际数组为准，避免旧 mirror_temper 不同步导致满纹被误判为未满。
execute if score #t wp_core_kind matches 2 run function plm:weapon/affix/count
execute if score #t wp_core_kind matches 2 run scoreboard players operation #t wp_temper = #t wp_count
execute if score #t wp_core_kind matches 2 run function plm:weapon/table/full
execute if score #t wp_core_kind matches 2 if score #t wp_full matches 0 run function plm:weapon/table/temper
execute if score #t wp_core_kind matches 2 if score #t wp_full matches 1 run function plm:weapon/msg/temper_full
execute if score #t wp_core_kind matches 0 if score #t wp_old_ver matches 1 run function plm:weapon/msg/old_ver
execute if score #t wp_core_kind matches 0 if score #t wp_old_ver matches 0 run function plm:weapon/msg/no_target
