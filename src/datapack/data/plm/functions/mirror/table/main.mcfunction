# 磨镜台入口
# 前置：调用方需 positioned 到投掷器坐标
execute if score @s mirror_tbl_cool matches 1.. run return 0
scoreboard players set @s mirror_tbl_cool 10

execute unless block ~ ~ ~ minecraft:dropper run tellraw @s {"text":"[磨镜台] 找不到投掷器。","color":"red"}
execute unless block ~ ~ ~ minecraft:dropper run return 0

# 武器五纹：槽 3 为武器胚/ver2 镜武时交给新表；旧表只处理防具
function plm:weapon/table/is_context
execute if score #t wp_ctx matches 1 run function plm:weapon/table/main
execute if score #t wp_ctx matches 1 run return 0

scoreboard players set #t success 0
# #t diff = 1：某个动作已识别输入但拒绝执行（例如全锁磨镜、未磨镜定影、多镜胚拼镜），
# 用于抑制重复的「材料不匹配」提示。
scoreboard players set #t diff 0
execute if data block ~ ~ ~ Items[{Slot:5b}] run tellraw @s {"text":"[磨镜台] 请先取走输出槽（第 6 格）的物品。","color":"yellow"}
execute if data block ~ ~ ~ Items[{Slot:5b}] run return 0

function plm:mirror/table/scan

# 动作意图（#t name）：1 拼镜 / 2 磨镜 / 3 定影 / 4 映度 / 5 分解。
# 只执行一个意图，失败就停，不再顺序落到后面（尤其不能落到无材料门槛的分解）。
scoreboard players set #t name 0
execute if score #t cnt_mold_sword matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_axe matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_bow matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_crossbow matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_twin matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_rub matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_helmet matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_chest matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_legs matches 1 run scoreboard players set #t name 1
execute if score #t cnt_mold_boots matches 1 run scoreboard players set #t name 1
execute if score #t name matches 0 if score #t cnt_sand matches 1 run scoreboard players set #t name 2
execute if score #t name matches 0 if score #t cnt_seal1 matches 1 run scoreboard players set #t name 3
execute if score #t name matches 0 if score #t cnt_seal2 matches 1 run scoreboard players set #t name 3
execute if score #t name matches 0 if score #t cnt_seal3 matches 1 run scoreboard players set #t name 3
execute if score #t name matches 0 if score #t cnt_core matches 1 run scoreboard players set #t name 4
execute if score #t name matches 0 if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run scoreboard players set #t name 5

execute if score #t name matches 1 if score #t success matches 0 run function plm:mirror/table/act/assemble
execute if score #t name matches 2 if score #t success matches 0 run function plm:mirror/table/act/polish
execute if score #t name matches 3 if score #t success matches 0 run function plm:mirror/table/act/seal
execute if score #t name matches 4 if score #t success matches 0 run function plm:mirror/table/act/degree
execute if score #t name matches 5 if score #t success matches 0 run function plm:mirror/table/act/dissolve

execute if score #t success matches 0 if score #t diff matches 0 run tellraw @s {"text":"[磨镜台] 材料不匹配。","color":"gray"}
scoreboard players set #t success 0
function plm:mirror/table/cleanup
