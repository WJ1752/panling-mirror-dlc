# 照心·真影律判定：@s=玩家。
# 武器不能替代 4 件防具映度，因此必须同时满足：
#   1) 照心防具件数（mirror_set_a - 武器计入）== 4；
#   2) 头/胸/腿/脚四个防具槽的 mirror_degree 全为 5。
# 结果写 mirror_true_law（1/0）；调用方在事件点即时调用，不依赖 5t tick 的缓存。
scoreboard players set @s mirror_true_law 0
scoreboard players set @s mirror_set_count 0
scoreboard players operation @s mirror_set_count = @s mirror_set_a
execute if score @s mirror_set matches 0 run scoreboard players operation @s mirror_set_count -= @s mirror_set_weapon
execute unless score @s mirror_set_count matches 4 run return 0
execute unless data entity @s Inventory[{Slot:103b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:102b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:101b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:100b,tag:{mirror:1,mirror_degree:5}}] run return 0
scoreboard players set @s mirror_true_law 1
