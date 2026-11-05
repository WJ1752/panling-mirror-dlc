# 镜装武器：自解析 mirror_base，写入本体的中介记分板
# 上下文：本体 equipment_lock/enable/main 在 ~ 255 ~ 处调用 #pld:weapon_unlock/enchant
# 只处理带 mirror:1 的物品，避免影响本体装备

execute unless data block ~ 255 ~ Items[0].tag.mirror run return 0

# ---- base ----
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.atk_pt store result score @s equipment_atk_pt_base1 run data get block ~ 255 ~ Items[0].tag.mirror_base.base.atk_pt 10
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.atk_sp store result score @s equipment_atk_sp_base1 run data get block ~ 255 ~ Items[0].tag.mirror_base.base.atk_sp 10

# ---- multiply_base ----
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_pt store result score @s equipment_atk_pt_multiply_base run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_pt
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.speed_pc store result score @s equipment_speed_pc_multiply_base run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.speed_pc
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_sp store result score @s equipment_atk_sp_multiply_base run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_sp

# ---- multiply ----
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply.atk_pt store result score @s equipment_atk_pt_multiply run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply.atk_pt

# ---- final_add ----
execute if data block ~ 255 ~ Items[0].tag.mirror_base.final_add.atk_pt store result score @s equipment_atk_pt_final_add1 run data get block ~ 255 ~ Items[0].tag.mirror_base.final_add.atk_pt 10
