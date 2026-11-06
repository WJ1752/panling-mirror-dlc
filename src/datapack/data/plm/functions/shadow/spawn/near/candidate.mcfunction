# 在玩家附近由高向低检查最多12格，适应斜坡；候选脚点本身必须位于影域。
scoreboard players set #found shadow_tmp 0
scoreboard players set #pack shadow_tmp 0
scoreboard players set #search shadow_tmp 12
execute if score @s shadow_spawn_dir matches 1 positioned ~16 ~4 ~ run function plm:shadow/spawn/near/search
execute if score @s shadow_spawn_dir matches 2 positioned ~-16 ~4 ~ run function plm:shadow/spawn/near/search
execute if score @s shadow_spawn_dir matches 3 positioned ~ ~4 ~16 run function plm:shadow/spawn/near/search
execute if score @s shadow_spawn_dir matches 4 positioned ~ ~4 ~-16 run function plm:shadow/spawn/near/search
