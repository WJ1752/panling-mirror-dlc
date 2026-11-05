# 洗统：镜缘×1/×2 + 影尘 15/30；只改 mirror_set/名称/lore，不碰五纹/锻位
function plm:weapon/table/scan
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute unless score #t wp_mat matches 4 run return 0
execute unless score #t wp_core_kind matches 2 run return 0

# 镜缘必须属于本器形的职业池
scoreboard players set #t wp_allowed 0
execute if score #t wp_form matches 1..2 if score #t wp_edge_set matches 0..1 run scoreboard players set #t wp_allowed 1
execute if score #t wp_form matches 3..4 if score #t wp_edge_set matches 2..3 run scoreboard players set #t wp_allowed 1
execute if score #t wp_form matches 5..6 if score #t wp_edge_set matches 4..5 run scoreboard players set #t wp_allowed 1
execute if score #t wp_allowed matches 0 run function plm:weapon/msg/bad_edge
execute if score #t wp_allowed matches 0 run return 0

# 槽 1：空=随机洗统；同套镜缘=定向；其他=拒绝
scoreboard players set #t wp_dir 0
execute if score #t wp_edge_set1 matches 0..5 if score #t wp_edge_set1 = #t wp_edge_set if score #t wp_have1 matches 1.. run scoreboard players set #t wp_dir 1
execute if score #t wp_edge_set1 matches 0..5 unless score #t wp_edge_set1 = #t wp_edge_set run function plm:weapon/msg/edge_pair
execute if score #t wp_edge_set1 matches 0..5 unless score #t wp_edge_set1 = #t wp_edge_set run return 0
execute if score #t wp_sub_sand matches 1 run function plm:weapon/msg/edge_pair
execute if score #t wp_sub_sand matches 1 run return 0
execute if score #t wp_have1 matches 1.. if score #t wp_sub_sand matches 0 if score #t wp_edge_set1 matches -1 run function plm:weapon/msg/edge_pair
execute if score #t wp_have1 matches 1.. if score #t wp_sub_sand matches 0 if score #t wp_edge_set1 matches -1 run return 0

# 成本
execute if score #t wp_dir matches 0 run scoreboard players operation #t wp_need_dust = #sys wp_set_dust_random
execute if score #t wp_dir matches 1 run scoreboard players operation #t wp_need_dust = #sys wp_set_dust_directed
function plm:weapon/table/check/dust
execute if score #t wp_abort matches 1 run return 0
execute if score #t wp_have0 matches ..0 run function plm:weapon/msg/need_edge
execute if score #t wp_have0 matches ..0 run return 0

# 结果镜统：定向=投入套；随机=70% 投入套 / 30% 另一套
execute if score #t wp_dir matches 1 run scoreboard players operation #t wp_mset = #t wp_edge_set
execute if score #t wp_dir matches 0 run function plm:weapon/util/rand100
execute if score #t wp_dir matches 0 if score #t wp_rand matches ..70 run scoreboard players operation #t wp_mset = #t wp_edge_set
execute if score #t wp_dir matches 0 if score #t wp_rand matches 71.. run function plm:weapon/table/set_other

# 扣缘：槽 0 一枚；定向再从槽 1 扣一枚
scoreboard players set #t wp_need 1
scoreboard players operation #t wp_left = #t wp_have0
scoreboard players operation #t wp_left -= #t wp_need
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_0
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
execute if score #t wp_dir matches 1 run function plm:weapon/table/set_take_slot1
function plm:weapon/table/take_dust

# 移到输出位，改名 + 重写 lore（不碰五纹/锻位）
item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3
data remove block ~ ~ ~ Items[{Slot:3b}]
function plm:weapon/table/name
function plm:weapon/table/lore

scoreboard players set #t wp_success 1
tellraw @s {"text":"[磨镜台] 洗统完成——只改了镜统与名称，五纹和锻位未动。","color":"aqua"}
