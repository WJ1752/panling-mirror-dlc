# 遗迹三个候选各自寻找安全地面，斜坡某一点不合格不再阻断整组。
scoreboard players set #pack shadow_tmp 1
scoreboard players set @s shadow_spawn_dir 1
scoreboard players set #found shadow_tmp 0
scoreboard players set #search shadow_tmp 12
execute positioned ~1 ~4 ~ run function plm:shadow/spawn/near/search
scoreboard players set @s shadow_spawn_dir 2
scoreboard players set #found shadow_tmp 0
scoreboard players set #search shadow_tmp 12
execute positioned ~-1 ~4 ~1 run function plm:shadow/spawn/near/search
scoreboard players set @s shadow_spawn_dir 3
scoreboard players set #found shadow_tmp 0
scoreboard players set #search shadow_tmp 12
execute positioned ~ ~4 ~-1 run function plm:shadow/spawn/near/search
scoreboard players set #pack shadow_tmp 0
scoreboard players set @s shadow_spawn_cd 30
