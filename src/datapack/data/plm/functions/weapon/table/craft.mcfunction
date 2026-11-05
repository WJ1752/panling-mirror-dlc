# 合成：槽 3 镜胚 + 槽 0 镜片×4 + 槽 8 影尘×10 → 0 纹成品（槽 5）
function plm:weapon/table/scan
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute unless score #t wp_mat matches 1 run return 0
execute unless score #t wp_core_kind matches 1 run return 0
execute if score #t wp_form matches 0 run return 0

scoreboard players operation #t wp_need_shard = #sys wp_craft_shard
scoreboard players operation #t wp_need_dust = #sys wp_craft_dust
function plm:weapon/table/check/shard
execute if score #t wp_abort matches 1 run return 0
function plm:weapon/table/check/dust
execute if score #t wp_abort matches 1 run return 0

# 抽本职业镜统并生成成品
function plm:weapon/table/roll_set
function plm:weapon/table/output

# 扣料：镜胚 1（槽 3）、镜片 4（槽 0）、影尘 10（槽 8）
scoreboard players set #t wp_need 1
scoreboard players operation #t wp_left = #t wp_have3
scoreboard players operation #t wp_left -= #t wp_need
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_3
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:3b}]
scoreboard players operation #t wp_need = #sys wp_craft_shard
scoreboard players operation #t wp_left = #t wp_have0
scoreboard players operation #t wp_left -= #t wp_need
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_0
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
function plm:weapon/table/take_dust

function plm:weapon/table/lore
scoreboard players set #t wp_success 1
tellraw @s {"text":"[磨镜台] 合成完成——0 纹镜武已出现在输出格。","color":"aqua"}
