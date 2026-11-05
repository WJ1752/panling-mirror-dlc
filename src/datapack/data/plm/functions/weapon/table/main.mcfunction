# 武器五纹磨镜台 · 玩家入口（10t 冷却）
execute if score @s wp_tbl_cool matches 1.. run return 0
scoreboard players set @s wp_tbl_cool 10

execute unless block ~ ~ ~ minecraft:dropper run tellraw @s {"text":"[磨镜台] 找不到投掷器。","color":"red"}
execute unless block ~ ~ ~ minecraft:dropper run return 0

function plm:weapon/table/act
function plm:weapon/table/cleanup
