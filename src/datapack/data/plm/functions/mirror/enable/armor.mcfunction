# 镜装防具：自解析 mirror_base，写入本体的中介记分板 + DLC 的防具基础值
# 上下文：本体 equipment_lock/enable/main 在 ~ 255 ~ 处调用 #pld:armor_unlock/enchant

execute unless data block ~ 255 ~ Items[0].tag.mirror run return 0

# 先清 DLC 自己的三项，避免重激活时残留
scoreboard players reset @s mirror_armor_base
scoreboard players reset @s mirror_toughness_base
scoreboard players reset @s mirror_health_base

# ---- 通用攻击字段（防具若配置了才写）----
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.atk_pt store result score @s equipment_atk_pt_base1 run data get block ~ 255 ~ Items[0].tag.mirror_base.base.atk_pt 10
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.atk_sp store result score @s equipment_atk_sp_base1 run data get block ~ 255 ~ Items[0].tag.mirror_base.base.atk_sp 10
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_pt store result score @s equipment_atk_pt_multiply_base run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_pt
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_sp store result score @s equipment_atk_sp_multiply_base run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply_base.atk_sp
execute if data block ~ 255 ~ Items[0].tag.mirror_base.multiply.atk_pt store result score @s equipment_atk_pt_multiply run data get block ~ 255 ~ Items[0].tag.mirror_base.multiply.atk_pt
execute if data block ~ 255 ~ Items[0].tag.mirror_base.final_add.atk_pt store result score @s equipment_atk_pt_final_add1 run data get block ~ 255 ~ Items[0].tag.mirror_base.final_add.atk_pt 10

# ---- 防具基础值（DLC 自用，供套装/镜律读取）----
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.armor store result score @s mirror_armor_base run data get block ~ 255 ~ Items[0].tag.mirror_base.base.armor 10
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.toughness store result score @s mirror_toughness_base run data get block ~ 255 ~ Items[0].tag.mirror_base.base.toughness 10
execute if data block ~ 255 ~ Items[0].tag.mirror_base.base.health store result score @s mirror_health_base run data get block ~ 255 ~ Items[0].tag.mirror_base.base.health 10
