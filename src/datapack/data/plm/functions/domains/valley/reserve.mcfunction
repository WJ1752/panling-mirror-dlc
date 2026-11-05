scoreboard players add #slots dm_party 1
scoreboard players add #next dm_run 1
scoreboard players operation #valley dm_run = #next dm_run
scoreboard players operation #valley dm_depth = @s dm_depth
scoreboard players set #valley dm_party 0
scoreboard players set #valley dm_state 1
scoreboard players set #valley dm_time 100
execute in plm:domains run forceload add 1024 0 1119 31
