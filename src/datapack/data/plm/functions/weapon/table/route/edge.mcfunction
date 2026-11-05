# 槽 0 镜缘：洗统（不改五纹/锻位）
execute if score #t wp_core_kind matches 2 run function plm:weapon/table/set_reroll
execute if score #t wp_old_ver matches 1 run function plm:weapon/msg/old_ver
execute if score #t wp_core_kind matches 0 if score #t wp_old_ver matches 0 run function plm:weapon/msg/no_target
