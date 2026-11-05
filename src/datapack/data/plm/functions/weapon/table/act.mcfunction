# 武器五纹磨镜台 · 玩家无关核心
# 按槽 0 材料分流：镜片=开纹/合成、砺镜砂=洗练、倒影核=淬纹、镜缘=洗统、燧石=分解
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
execute if data block ~ ~ ~ Items[{Slot:5b}] run tellraw @s {"text":"[磨镜台] 请先取走输出槽（第 6 格）的物品。","color":"yellow"}
execute if data block ~ ~ ~ Items[{Slot:5b}] run return 0
function plm:weapon/table/scan
execute if score #t wp_mat matches 1 run function plm:weapon/table/route/lens
execute if score #t wp_mat matches 2 run function plm:weapon/table/route/sand
execute if score #t wp_mat matches 3 run function plm:weapon/table/route/core
execute if score #t wp_mat matches 4 run function plm:weapon/table/route/edge
execute if score #t wp_mat matches 5 run function plm:weapon/table/route/flint
execute if score #t wp_success matches 0 if score #t wp_msg matches 0 run function plm:weapon/msg/generic
