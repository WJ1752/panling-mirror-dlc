# 套装分档公共计算（残影 / 双生 / 拓印共用）
# 输入：#t mirror_set_tmp = 套装编号 3/4/5（d=残影 / e=双生 / f=拓印）
# 本体 armor_set_bonus_id_* 对 DLC 套装是 10-15（照心10..拓印15），所以比较键 = #t+10。
# 输出（@s）：
#   mirror_set_count = 该套防具件数（不含武器）
#   mirror_set_4     = 1 表示 4 件套成立：件数够且四件映度≥3（3 防具 + 同套满锻武器时武器视为满足）
#   mirror_true_law  = 1 表示 4 件该套防具的 mirror_degree 全为 5（武器不计）
#   mirror_set_tier  = 0 / 2 / 4 / 5
# 直接按四个防具槽 + 主手镜武重算，不依赖 mirror_set_a..f：
# 共享 count 被 #pld:equipment_lock/armor/set_check 和 plm:weapon/set/count 两次调用时，
# 武器可能被重复 +1；这里只把武器算一次，保证 2/4 件套判定稳定。
scoreboard players set @s mirror_set_count 0
scoreboard players operation #t_id mirror_set_tmp = #t mirror_set_tmp
scoreboard players add #t_id mirror_set_tmp 10
execute if score @s armor_set_bonus_id_head = #t_id mirror_set_tmp run scoreboard players add @s mirror_set_count 1
execute if score @s armor_set_bonus_id_chest = #t_id mirror_set_tmp run scoreboard players add @s mirror_set_count 1
execute if score @s armor_set_bonus_id_legs = #t_id mirror_set_tmp run scoreboard players add @s mirror_set_count 1
execute if score @s armor_set_bonus_id_feet = #t_id mirror_set_tmp run scoreboard players add @s mirror_set_count 1

# 4 件套 = 件数够 + 四件映度≥3（主文档 §1）；3 防具 + 同套满锻武器时武器视为满足
scoreboard players set @s mirror_set_4 0
function plm:mirror/set/tier_gate
execute if score @s mirror_set_count matches 3.. if score #t ok matches 1 run scoreboard players set @s mirror_set_4 1

# 真影律：4 件防具全部是该套、且 mirror_degree 全 5；武器不能替代
scoreboard players set @s mirror_true_law 1
execute unless score @s mirror_set_count matches 4.. run scoreboard players set @s mirror_true_law 0
execute unless score @s armor_set_bonus_id_head = #t_id mirror_set_tmp run scoreboard players set @s mirror_true_law 0
execute unless score @s armor_set_bonus_id_chest = #t_id mirror_set_tmp run scoreboard players set @s mirror_true_law 0
execute unless score @s armor_set_bonus_id_legs = #t_id mirror_set_tmp run scoreboard players set @s mirror_true_law 0
execute unless score @s armor_set_bonus_id_feet = #t_id mirror_set_tmp run scoreboard players set @s mirror_true_law 0
# 读不到镜度（非镜装/空槽）时 #t mirror_set_4 保持 -1，下面判 5 不成立
execute if score @s mirror_true_law matches 1 run scoreboard players set #t mirror_set_4 -1
execute if score @s mirror_true_law matches 1 store result score #t mirror_set_4 run data get entity @s Inventory[{Slot:103b}].tag.mirror_degree
execute if score @s mirror_true_law matches 1 unless score #t mirror_set_4 matches 5 run scoreboard players set @s mirror_true_law 0
execute if score @s mirror_true_law matches 1 run scoreboard players set #t mirror_set_4 -1
execute if score @s mirror_true_law matches 1 store result score #t mirror_set_4 run data get entity @s Inventory[{Slot:102b}].tag.mirror_degree
execute if score @s mirror_true_law matches 1 unless score #t mirror_set_4 matches 5 run scoreboard players set @s mirror_true_law 0
execute if score @s mirror_true_law matches 1 run scoreboard players set #t mirror_set_4 -1
execute if score @s mirror_true_law matches 1 store result score #t mirror_set_4 run data get entity @s Inventory[{Slot:101b}].tag.mirror_degree
execute if score @s mirror_true_law matches 1 unless score #t mirror_set_4 matches 5 run scoreboard players set @s mirror_true_law 0
execute if score @s mirror_true_law matches 1 run scoreboard players set #t mirror_set_4 -1
execute if score @s mirror_true_law matches 1 store result score #t mirror_set_4 run data get entity @s Inventory[{Slot:100b}].tag.mirror_degree
execute if score @s mirror_true_law matches 1 unless score #t mirror_set_4 matches 5 run scoreboard players set @s mirror_true_law 0

# 分档：5 = 真影律，4 = 4 件套，2 = 2 件套
scoreboard players set @s mirror_set_tier 0
execute if score @s mirror_set_count matches 2.. run scoreboard players set @s mirror_set_tier 2
execute if score @s mirror_set_4 matches 1 run scoreboard players set @s mirror_set_tier 4
execute if score @s mirror_true_law matches 1 run scoreboard players set @s mirror_set_tier 5
