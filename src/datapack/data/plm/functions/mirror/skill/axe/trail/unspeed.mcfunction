# 影随 · 到期清理（每个维度各调一次；只处理带本 tag 的实体）
# 1s（20t）后移除 generic.movement_speed 的固定 UUID modifier。
execute as @e[tag=mirror_axe_ying_sui] if score @s mirror_shadow_hit_due <= #sys mirror_game_time run function plm:mirror/skill/axe/trail/unspeed_one
