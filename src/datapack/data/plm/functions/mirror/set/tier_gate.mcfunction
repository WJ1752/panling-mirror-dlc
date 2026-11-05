# 4 件套映度门槛：@s = 玩家；#t mirror_set_tmp = 套装编号 0..5
# 输出：#t ok = 1 表示满足「四件映度≥3」（主文档 §1「镜套装：4 件＋四件映度≥3」）。
# 规则：4 件该套防具且每件 mirror_degree >= 3；
#       或 3 件该套防具（均 >=3）+ 主手同套满锻武器（mirror_temper = 5，武器合成 §4.3）。
# 真影律仍是四件全 5，武器不替代；本函数不参与真影律判定。
scoreboard players set #t ok 0
scoreboard players set #t count 0
scoreboard players set #t left 0
scoreboard players operation #t_id mirror_set_tmp = #t mirror_set_tmp
scoreboard players add #t_id mirror_set_tmp 10

# 头（Slot:103b）
scoreboard players set #t deg 0
execute if score @s armor_set_bonus_id_head = #t_id mirror_set_tmp run scoreboard players add #t count 1
execute if score @s armor_set_bonus_id_head = #t_id mirror_set_tmp store result score #t deg run data get entity @s Inventory[{Slot:103b}].tag.mirror_degree
execute if score @s armor_set_bonus_id_head = #t_id mirror_set_tmp if score #t deg matches 3.. run scoreboard players add #t left 1

# 胸（Slot:102b）
scoreboard players set #t deg 0
execute if score @s armor_set_bonus_id_chest = #t_id mirror_set_tmp run scoreboard players add #t count 1
execute if score @s armor_set_bonus_id_chest = #t_id mirror_set_tmp store result score #t deg run data get entity @s Inventory[{Slot:102b}].tag.mirror_degree
execute if score @s armor_set_bonus_id_chest = #t_id mirror_set_tmp if score #t deg matches 3.. run scoreboard players add #t left 1

# 腿（Slot:101b）
scoreboard players set #t deg 0
execute if score @s armor_set_bonus_id_legs = #t_id mirror_set_tmp run scoreboard players add #t count 1
execute if score @s armor_set_bonus_id_legs = #t_id mirror_set_tmp store result score #t deg run data get entity @s Inventory[{Slot:101b}].tag.mirror_degree
execute if score @s armor_set_bonus_id_legs = #t_id mirror_set_tmp if score #t deg matches 3.. run scoreboard players add #t left 1

# 脚（Slot:100b）
scoreboard players set #t deg 0
execute if score @s armor_set_bonus_id_feet = #t_id mirror_set_tmp run scoreboard players add #t count 1
execute if score @s armor_set_bonus_id_feet = #t_id mirror_set_tmp store result score #t deg run data get entity @s Inventory[{Slot:100b}].tag.mirror_degree
execute if score @s armor_set_bonus_id_feet = #t_id mirror_set_tmp if score #t deg matches 3.. run scoreboard players add #t left 1

# 四件防具全满足
execute if score #t count matches 4 if score #t left matches 4 run scoreboard players set #t ok 1
# 三件防具 + 同套满锻武器
execute if score #t count matches 3 if score #t left matches 3 if entity @s[tag=mirror_weapon_active] if score @s mirror_parse_ok matches 1 if score @s mirror_set = #t mirror_set_tmp if score @s mirror_temper matches 5 run scoreboard players set #t ok 1
