scoreboard players add #slots dm_party 1
scoreboard players add #next dm_run 1
scoreboard players operation #fire dm_run = #next dm_run
scoreboard players operation #fire dm_depth = @s dm_depth
scoreboard players set #fire dm_party 0
scoreboard players set #fire dm_state 1
scoreboard players set #fire dm_time 100
execute in plm:domains run forceload add 256 0 351 31
