function plm:domains/mountain/cleanup
execute as @a[tag=plm_d_mountain] run function plm:domains/mountain/leave
scoreboard players reset #mountain dm_run
scoreboard players set #mountain dm_state 0
scoreboard players set #mountain dm_deaths 0
scoreboard players remove #slots dm_party 1
forceload remove 1280 0 1375 31
kill @s
