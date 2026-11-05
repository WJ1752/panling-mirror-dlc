scoreboard players add #slots dm_party 1
scoreboard players add #next dm_run 1
scoreboard players operation #tower dm_run = #next dm_run
scoreboard players operation #tower dm_depth = @s dm_depth
scoreboard players set #tower dm_party 0
scoreboard players set #tower dm_state 1
scoreboard players set #tower dm_time 100
execute in plm:domains run forceload add 768 0 863 31
