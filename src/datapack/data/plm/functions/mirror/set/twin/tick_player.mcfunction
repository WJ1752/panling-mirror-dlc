# 双生套装单玩家 5t（@s=玩家）
scoreboard players set #t mirror_set_tmp 4
function plm:mirror/set/can/tier

# 2 件套：阵法命中即叠共鸣；基础上限 3，2 件套 +1 → 4（设计 §4.6）
scoreboard players set @s mirror_resonance_max 3
execute if score @s mirror_set_count matches 2.. run scoreboard players set @s mirror_resonance_max 4

# mirror_twin_4_until：4 件套期间的滚动时间戳（读取点判断，不做全局 tick）
execute if score @s mirror_set_4 matches 1 run scoreboard players operation @s mirror_twin_4_until = #sys mirror_game_time
execute if score @s mirror_set_4 matches 1 run scoreboard players add @s mirror_twin_4_until 200
execute if score @s mirror_set_4 matches 0 run scoreboard players set @s mirror_twin_4_until 0
