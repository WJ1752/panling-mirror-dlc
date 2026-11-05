# 洗练：五纹已满（锻位=5）；砺镜砂×1 + 影尘×30；类别/词条/数值按 A–E 形状全重抽
function plm:weapon/table/scan
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute unless score #t wp_mat matches 2 run return 0
execute unless score #t wp_core_kind matches 2 run return 0
# 锻位以当前有效五纹数（DMG+SKL+FX）为准，避免旧 mirror_temper 不同步。
function plm:weapon/affix/count
scoreboard players operation #t wp_temper = #t wp_count
function plm:weapon/table/full
execute if score #t wp_full matches 0 run function plm:weapon/msg/not_full
execute if score #t wp_full matches 0 run return 0

scoreboard players operation #t wp_need_sand = #sys wp_reroll_sand
scoreboard players operation #t wp_need_dust = #sys wp_reroll_dust
execute if score #t wp_have0 < #t wp_need_sand run scoreboard players operation #t wp_diff = #t wp_need_sand
execute if score #t wp_have0 < #t wp_need_sand run scoreboard players operation #t wp_diff -= #t wp_have0
execute if score #t wp_have0 < #t wp_need_sand run function plm:weapon/msg/need_sand
execute if score #t wp_have0 < #t wp_need_sand run return 0
function plm:weapon/table/check/dust
execute if score #t wp_abort matches 1 run return 0

# 整体重抽（镜统不动；形状 A–E + 类别配额，结果固定 5 条）
function plm:weapon/affix/reroll_all

# 锻位 = 重抽后的有效五纹数（DMG+SKL+FX），正常应为 5
function plm:weapon/affix/count
scoreboard players operation #t wp_temper = #t wp_n_dmg
scoreboard players operation #t wp_temper += #t wp_n_skl
scoreboard players operation #t wp_temper += #t wp_n_fx
execute store result storage plm:weapon tmp int 1 run scoreboard players get #t wp_temper
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_temper set from storage plm:weapon tmp

# 扣料：砂 1（槽 0）、尘 30（槽 8）
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
tellraw @s {"text":"[磨镜台] 洗练完成——镜纹已全部重抽，结果可能更差。","color":"aqua"}
