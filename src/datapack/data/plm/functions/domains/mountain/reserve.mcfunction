scoreboard players add #slots dm_party 1
scoreboard players add #next dm_run 1
scoreboard players operation #mountain dm_run = #next dm_run
scoreboard players operation #mountain dm_depth = @s dm_depth
scoreboard players set #mountain dm_party 0
scoreboard players set #mountain dm_state 1
scoreboard players set #mountain dm_time 100
execute in plm:domains run forceload add 1280 0 1375 31
