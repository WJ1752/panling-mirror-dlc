# 镜花·真影律判定：@s=玩家。
# 武器不能替代 4 件防具映度：镜花防具件数 == 4，且四个防具槽 mirror_degree 全 5。
# 结果写 mirror_true_law（1/0）；镜花起手时即时调用。
scoreboard players set @s mirror_true_law 0
scoreboard players set @s mirror_set_count 0
scoreboard players operation @s mirror_set_count = @s mirror_set_c
execute if score @s mirror_set matches 2 run scoreboard players operation @s mirror_set_count -= @s mirror_set_weapon
execute unless score @s mirror_set_count matches 4 run return 0
execute unless data entity @s Inventory[{Slot:103b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:102b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:101b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:100b,tag:{mirror:1,mirror_degree:5}}] run return 0
scoreboard players set @s mirror_true_law 1
