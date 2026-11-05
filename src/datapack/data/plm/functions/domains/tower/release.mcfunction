function plm:domains/tower/cleanup
execute as @a[tag=plm_d_tower] run function plm:domains/tower/leave
scoreboard players reset #tower dm_run
scoreboard players set #tower dm_state 0
scoreboard players set #tower dm_deaths 0
scoreboard players remove #slots dm_party 1
forceload remove 768 0 863 31
kill @s
