# @s为影域wilderness玩家，每5秒最多尝试一个四向位置。
scoreboard players set @s shadow_player_spawn_cd 5
scoreboard players set @s shadow_spawn_dir 0
execute if predicate plm:shadow/spawn_quarter run scoreboard players set @s shadow_spawn_dir 1
execute if score @s shadow_spawn_dir matches 0 if predicate plm:shadow/spawn_third run scoreboard players set @s shadow_spawn_dir 2
execute if score @s shadow_spawn_dir matches 0 if predicate plm:shadow/spawn_half run scoreboard players set @s shadow_spawn_dir 3
execute if score @s shadow_spawn_dir matches 0 run scoreboard players set @s shadow_spawn_dir 4
execute if score #shadow shadow_mob_count matches ..44 run function plm:shadow/spawn/near/candidate
