# 槽 0 砺镜砂：本器形 Phase 1 可开纹数已满时洗练；未满由 reroll 自己提示
execute if score #t wp_core_kind matches 2 run function plm:weapon/table/reroll
execute if score #t wp_old_ver matches 1 run function plm:weapon/msg/old_ver
execute if score #t wp_core_kind matches 0 if score #t wp_old_ver matches 0 run function plm:weapon/msg/no_target
