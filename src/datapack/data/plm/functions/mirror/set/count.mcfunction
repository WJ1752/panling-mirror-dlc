# 镜装套装计数：把 armor_set_bonus_id_* 的 10-15 段位映射到 mirror_set_a..f
# 由 #pld:equipment_lock/armor/set_check 调用（本体 clear_bonus 已先清理）

scoreboard players set @s mirror_set_a 0
scoreboard players set @s mirror_set_b 0
scoreboard players set @s mirror_set_c 0
scoreboard players set @s mirror_set_d 0
scoreboard players set @s mirror_set_e 0
scoreboard players set @s mirror_set_f 0

# 照心 10
execute if score @s armor_set_bonus_id_head matches 10 run scoreboard players add @s mirror_set_a 1
execute if score @s armor_set_bonus_id_chest matches 10 run scoreboard players add @s mirror_set_a 1
execute if score @s armor_set_bonus_id_legs matches 10 run scoreboard players add @s mirror_set_a 1
execute if score @s armor_set_bonus_id_feet matches 10 run scoreboard players add @s mirror_set_a 1

# 裂影 11
execute if score @s armor_set_bonus_id_head matches 11 run scoreboard players add @s mirror_set_b 1
execute if score @s armor_set_bonus_id_chest matches 11 run scoreboard players add @s mirror_set_b 1
execute if score @s armor_set_bonus_id_legs matches 11 run scoreboard players add @s mirror_set_b 1
execute if score @s armor_set_bonus_id_feet matches 11 run scoreboard players add @s mirror_set_b 1

# 镜花 12
execute if score @s armor_set_bonus_id_head matches 12 run scoreboard players add @s mirror_set_c 1
execute if score @s armor_set_bonus_id_chest matches 12 run scoreboard players add @s mirror_set_c 1
execute if score @s armor_set_bonus_id_legs matches 12 run scoreboard players add @s mirror_set_c 1
execute if score @s armor_set_bonus_id_feet matches 12 run scoreboard players add @s mirror_set_c 1

# 残影 13
execute if score @s armor_set_bonus_id_head matches 13 run scoreboard players add @s mirror_set_d 1
execute if score @s armor_set_bonus_id_chest matches 13 run scoreboard players add @s mirror_set_d 1
execute if score @s armor_set_bonus_id_legs matches 13 run scoreboard players add @s mirror_set_d 1
execute if score @s armor_set_bonus_id_feet matches 13 run scoreboard players add @s mirror_set_d 1

# 双生 14
execute if score @s armor_set_bonus_id_head matches 14 run scoreboard players add @s mirror_set_e 1
execute if score @s armor_set_bonus_id_chest matches 14 run scoreboard players add @s mirror_set_e 1
execute if score @s armor_set_bonus_id_legs matches 14 run scoreboard players add @s mirror_set_e 1
execute if score @s armor_set_bonus_id_feet matches 14 run scoreboard players add @s mirror_set_e 1

# 拓印 15
execute if score @s armor_set_bonus_id_head matches 15 run scoreboard players add @s mirror_set_f 1
execute if score @s armor_set_bonus_id_chest matches 15 run scoreboard players add @s mirror_set_f 1
execute if score @s armor_set_bonus_id_legs matches 15 run scoreboard players add @s mirror_set_f 1
execute if score @s armor_set_bonus_id_feet matches 15 run scoreboard players add @s mirror_set_f 1

# 本函数只数四个防具槽。主手镜武由 plm:weapon/set/count 统一 +1，
# 避免 #pld:equipment_lock/armor/set_check 同时调用两者时武器被重复计数。
scoreboard players set @s mirror_set_weapon 0
