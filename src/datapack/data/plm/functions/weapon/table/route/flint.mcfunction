# 槽 0 燧石：分解 mirror_ver:2 镜武
execute if score #t wp_core_kind matches 2 run function plm:weapon/table/dissolve
execute if score #t wp_old_ver matches 1 run function plm:weapon/msg/old_ver
execute if score #t wp_core_kind matches 0 if score #t wp_old_ver matches 0 run function plm:weapon/msg/no_target
