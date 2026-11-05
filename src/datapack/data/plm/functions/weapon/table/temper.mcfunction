# 开纹：锻位 0..5；按 §3.2 扣影尘/镜片/砺镜砂；+1 条镜纹；mirror_temper 按有效纹数重算
function plm:weapon/table/scan
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute unless score #t wp_mat matches 1 run return 0
execute unless score #t wp_core_kind matches 2 run return 0
execute unless score #t wp_temper matches 0..5 run return 0

# 锻位以有效五纹数为准；旧物品若 mirror_temper 与数组不同步，先按 DMG+SKL+FX 重算。
function plm:weapon/affix/count
scoreboard players operation #t wp_temper = #t wp_count

# 五纹上限 5（所有器形）：先按上限拦截，避免满纹后仍进入成本检查/扣料。
function plm:weapon/table/full
execute if score #t wp_full matches 1 run function plm:weapon/msg/temper_full
execute if score #t wp_full matches 1 run return 0

# 按当前锻位取成本
execute if score #t wp_temper matches 0 run scoreboard players operation #t wp_need_dust = #sys wp_cost_dust_0
execute if score #t wp_temper matches 0 run scoreboard players operation #t wp_need_shard = #sys wp_cost_shard_0
execute if score #t wp_temper matches 0 run scoreboard players operation #t wp_need_sand = #sys wp_cost_sand_0
execute if score #t wp_temper matches 1 run scoreboard players operation #t wp_need_dust = #sys wp_cost_dust_1
execute if score #t wp_temper matches 1 run scoreboard players operation #t wp_need_shard = #sys wp_cost_shard_1
execute if score #t wp_temper matches 1 run scoreboard players operation #t wp_need_sand = #sys wp_cost_sand_1
execute if score #t wp_temper matches 2 run scoreboard players operation #t wp_need_dust = #sys wp_cost_dust_2
execute if score #t wp_temper matches 2 run scoreboard players operation #t wp_need_shard = #sys wp_cost_shard_2
execute if score #t wp_temper matches 2 run scoreboard players operation #t wp_need_sand = #sys wp_cost_sand_2
execute if score #t wp_temper matches 3 run scoreboard players operation #t wp_need_dust = #sys wp_cost_dust_3
execute if score #t wp_temper matches 3 run scoreboard players operation #t wp_need_shard = #sys wp_cost_shard_3
execute if score #t wp_temper matches 3 run scoreboard players operation #t wp_need_sand = #sys wp_cost_sand_3
execute if score #t wp_temper matches 4 run scoreboard players operation #t wp_need_dust = #sys wp_cost_dust_4
execute if score #t wp_temper matches 4 run scoreboard players operation #t wp_need_shard = #sys wp_cost_shard_4
execute if score #t wp_temper matches 4 run scoreboard players operation #t wp_need_sand = #sys wp_cost_sand_4
function plm:weapon/table/check/shard
function plm:weapon/table/check/dust
function plm:weapon/table/check/sand
execute if score #t wp_abort matches 1 run return 0

# 长出一条镜纹；只有真正追加了词条才算成功，否则不扣料/不涨锻位。
function plm:weapon/affix/add_one
execute if score #t wp_added matches 0 run function plm:weapon/msg/temper_full
execute if score #t wp_added matches 0 run return 0
# 锻位 = 当前有效五纹数（DMG+SKL+FX），不是简单 +1。
function plm:weapon/affix/count
scoreboard players operation #t wp_temper = #t wp_count
execute store result storage plm:weapon tmp int 1 run scoreboard players get #t wp_temper
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_temper set from storage plm:weapon tmp

# 扣料
function plm:weapon/table/take_dust
scoreboard players operation #t wp_left = #t wp_have0
scoreboard players operation #t wp_left -= #t wp_need_shard
execute if score #t wp_left matches 1.. run function plm:weapon/table/take/set_0
execute if score #t wp_left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
execute if score #t wp_need_sand matches 1.. run function plm:weapon/table/temper_sand_take

# 移到输出位（禁止 data merge Items 整表覆盖）
item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3
data remove block ~ ~ ~ Items[{Slot:3b}]
function plm:weapon/table/lore

scoreboard players set #t wp_success 1
tellraw @s {"text":"[磨镜台] 开纹成功——镜纹 +1。","color":"aqua"}
