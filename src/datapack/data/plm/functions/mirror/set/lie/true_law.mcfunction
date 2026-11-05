# 裂影·真影律判定：@s=玩家。
# 武器不能替代 4 件防具映度：必须裂影防具件数（mirror_set_b - 武器计入）== 4，
# 且头/胸/腿/脚四个防具槽 mirror_degree 全为 5。
# 结果写 mirror_true_law（1/0）；在裂痕引爆时即时调用，不做 5t 缓存。
scoreboard players set @s mirror_true_law 0
scoreboard players set @s mirror_set_count 0
scoreboard players operation @s mirror_set_count = @s mirror_set_b
execute if score @s mirror_set matches 1 run scoreboard players operation @s mirror_set_count -= @s mirror_set_weapon
execute unless score @s mirror_set_count matches 4 run return 0
execute unless data entity @s Inventory[{Slot:103b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:102b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:101b,tag:{mirror:1,mirror_degree:5}}] run return 0
execute unless data entity @s Inventory[{Slot:100b,tag:{mirror:1,mirror_degree:5}}] run return 0
scoreboard players set @s mirror_true_law 1
