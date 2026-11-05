# 淬纹：本器形 Phase 1 可开纹数已满；倒影核×1 + 影尘×20；镜纹种类不变、数值全重抽（允许变低）
function plm:weapon/table/scan
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute unless score #t wp_mat matches 3 run return 0
execute unless score #t wp_core_kind matches 2 run return 0
# 锻位以实际五纹数（DMG+SKL+FX）为准；旧物品 mirror_temper 不同步时先修复，再判定是否满纹。
function plm:weapon/affix/count
scoreboard players operation #t wp_temper = #t wp_count
execute store result storage plm:weapon tmp int 1 run scoreboard players get #t wp_temper
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_temper set from storage plm:weapon tmp
function plm:weapon/table/full
execute if score #t wp_full matches 0 run function plm:weapon/msg/not_full
execute if score #t wp_full matches 0 run return 0

scoreboard players operation #t wp_need_core = #sys wp_quench_core
scoreboard players operation #t wp_need_dust = #sys wp_quench_dust
function plm:weapon/table/check/core
execute if score #t wp_abort matches 1 run return 0
function plm:weapon/table/check/dust
execute if score #t wp_abort matches 1 run return 0

function plm:weapon/affix/quench_all

# 扣料：核 1（槽 0）、尘 20（槽 8）
scoreboard players set #t wp_need 1
scoreboard players operation #t wp_left = #t wp_have0
scoreboard players operation #t wp_left -= #t wp_need
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_0
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
function plm:weapon/table/take_dust

item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3
data remove block ~ ~ ~ Items[{Slot:3b}]
function plm:weapon/table/lore

scoreboard players set #t wp_success 1
tellraw @s {"text":"[磨镜台] 淬纹完成——镜纹种类不变，数值全部重抽，可能变低。","color":"aqua"}
