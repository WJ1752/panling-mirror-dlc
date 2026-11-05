# 开发/测试：把四个真实护甲槽的 NBT 读成本体 set_bonus 分数，再跑真实 set_check 标签。
# 用法：execute as <玩家> run function plm:dev/armor_scores
# 这不是生产路径；生产由本体 pld:equipment_lock/equipment/armor/main 读槽位。
# 空槽先置 -1，避免 store result 失败时沿用上一次的分数。

scoreboard players set @s armor_set_bonus_id_head -1
scoreboard players set @s armor_set_bonus_id_chest -1
scoreboard players set @s armor_set_bonus_id_legs -1
scoreboard players set @s armor_set_bonus_id_feet -1
scoreboard players set @s armor_rare_head 0
scoreboard players set @s armor_rare_chest 0
scoreboard players set @s armor_rare_legs 0
scoreboard players set @s armor_rare_feet 0

execute store result score @s armor_set_bonus_id_head run data get entity @s Inventory[{Slot:103b}].tag.set_bonus_id
execute store result score @s armor_set_bonus_id_chest run data get entity @s Inventory[{Slot:102b}].tag.set_bonus_id
execute store result score @s armor_set_bonus_id_legs run data get entity @s Inventory[{Slot:101b}].tag.set_bonus_id
execute store result score @s armor_set_bonus_id_feet run data get entity @s Inventory[{Slot:100b}].tag.set_bonus_id
execute store result score @s armor_rare_head run data get entity @s Inventory[{Slot:103b}].tag.rare
execute store result score @s armor_rare_chest run data get entity @s Inventory[{Slot:102b}].tag.rare
execute store result score @s armor_rare_legs run data get entity @s Inventory[{Slot:101b}].tag.rare
execute store result score @s armor_rare_feet run data get entity @s Inventory[{Slot:100b}].tag.rare

# 真实接口：本体 clear_bonus + 五套判定 + DLC 追加的套装计数
function #pld:equipment_lock/armor/set_check
