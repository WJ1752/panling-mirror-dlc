scoreboard players add #slots dm_party 1
scoreboard players add #next dm_run 1
scoreboard players operation #tomb dm_run = #next dm_run
scoreboard players operation #tomb dm_depth = @s dm_depth
scoreboard players set #tomb dm_party 0
scoreboard players set #tomb dm_state 1
scoreboard players set #tomb dm_time 100
execute in plm:domains run forceload add 512 0 607 31
