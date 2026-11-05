function plm:domains/valley/cleanup
execute as @a[tag=plm_d_valley] run function plm:domains/valley/leave
scoreboard players reset #valley dm_run
scoreboard players set #valley dm_state 0
scoreboard players set #valley dm_deaths 0
scoreboard players remove #slots dm_party 1
forceload remove 1024 0 1119 31
kill @s
