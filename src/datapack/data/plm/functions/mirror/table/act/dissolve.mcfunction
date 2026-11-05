# ---- 分解：槽3 镜装 → 返还镜胚 + 部分材料 ----
execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run return 0

# 判断器形，返还对应镜胚
scoreboard players set #t kind 0
scoreboard players set #t edge -1
scoreboard players set #t part -1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sword7"}}] run scoreboard players set #t kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_axe7"}}] run scoreboard players set #t kind 2
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_bow7"}}] run scoreboard players set #t kind 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_crossbow7"}}] run scoreboard players set #t kind 4
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_twin7"}}] run scoreboard players set #t kind 5
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_rub7"}}] run scoreboard players set #t kind 6

# 防具：六套共用一个 id 前缀（zhao_1 / lie_2 / jing_3 / can_4 / twin_5 / rub_6），
# 套装用 set_bonus_id 10..15 判定，部位用物品自带 tag.slot 0..3 判定。
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1,set_bonus_id:10}}] run scoreboard players set #t edge 0
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1,set_bonus_id:11}}] run scoreboard players set #t edge 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1,set_bonus_id:12}}] run scoreboard players set #t edge 2
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1,set_bonus_id:13}}] run scoreboard players set #t edge 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1,set_bonus_id:14}}] run scoreboard players set #t edge 4
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1,set_bonus_id:15}}] run scoreboard players set #t edge 5
execute if score #t edge matches 0.. run scoreboard players set #t kind 10
execute if score #t kind matches 10 unless data block ~ ~ ~ Items[{Slot:3b}].tag.slot run scoreboard players set #t kind 0
execute if score #t kind matches 10 store result score #t part run data get block ~ ~ ~ Items[{Slot:3b}].tag.slot
execute if score #t kind matches 10 unless score #t part matches 0..3 run scoreboard players set #t kind 0
execute if score #t kind matches 0 run return 0

# 防具元素（镜片返还同元素；0=金，缺省按金处理）
scoreboard players set #t elem 0
execute if score #t kind matches 10 store result score #t elem run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_elem

# 返还（武器胚 100%，防具胚 100%，防具另加镜片×2 + 影尘×5）
function plm:mirror/table/output/dissolve_return

# 清掉镜装
data remove block ~ ~ ~ Items[{Slot:3b}]

scoreboard players set #t success 1
tellraw @s {"text":"[磨镜台] 已分解：镜胚全额返还；防具另回收镜片×2、影尘×5。","color":"aqua"}
