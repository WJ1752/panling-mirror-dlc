# 分解：燧石；只认 mirror_ver:2；返还镜胚 100% + 镜片/影尘 60%；砂/核不退
# 60% 基数 = 合成成本（§2.3：镜片 4 / 影尘 10），不按锻位累计投入
function plm:weapon/table/scan
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute unless score #t wp_mat matches 5 run return 0
execute unless score #t wp_core_kind matches 2 run return 0
execute if score #t wp_form matches 0 run return 0

# 只有武器分解还会写槽 6、7；其它配方仍可使用这两格放材料。
execute if data block ~ ~ ~ Items[{Slot:6b}] run scoreboard players set #t wp_msg 1
execute if data block ~ ~ ~ Items[{Slot:7b}] run scoreboard players set #t wp_msg 1
execute if score #t wp_msg matches 1 run tellraw @s {"text":"[磨镜台] 请先腾出下排左、中两格，以接收分解返还的镜片和影尘。","color":"yellow"}
execute if score #t wp_msg matches 1 run return 0

# 返还基数：合成成本（镜片 4 / 影尘 10）
scoreboard players operation #t wp_total_shard = #sys wp_craft_shard
scoreboard players operation #t wp_total_dust = #sys wp_craft_dust

# 60%
scoreboard players operation #t wp_ret_shard = #t wp_total_shard
scoreboard players operation #t wp_ret_shard *= #sys wp_dissolve_pct
scoreboard players operation #t wp_ret_shard /= #sys wp_hundred
scoreboard players operation #t wp_ret_dust = #t wp_total_dust
scoreboard players operation #t wp_ret_dust *= #sys wp_dissolve_pct
scoreboard players operation #t wp_ret_dust /= #sys wp_hundred
execute if score #t wp_ret_shard < #sys wp_dissolve_min_shard run scoreboard players operation #t wp_ret_shard = #sys wp_dissolve_min_shard

# 扣燧石 1、移除镜武
scoreboard players operation #t wp_left = #t wp_have0
scoreboard players remove #t wp_left 1
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_0
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
data remove block ~ ~ ~ Items[{Slot:3b}]

# 输出：槽 5 镜胚 / 槽 6 镜片 / 槽 7 影尘
function plm:weapon/table/dissolve/mold
function plm:weapon/table/dissolve/shard
execute if score #t wp_ret_dust matches 1.. run function plm:weapon/table/dissolve/dust

scoreboard players set #t wp_success 1
tellraw @s [{"text":"[磨镜台] 分解完成：返还镜胚，镜片 ","color":"aqua"},{"score":{"name":"#t","objective":"wp_ret_shard"}},{"text":"、影尘 ","color":"aqua"},{"score":{"name":"#t","objective":"wp_ret_dust"}},{"text":"。","color":"aqua"}]
