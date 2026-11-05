function plm:domains/fire/cleanup
execute as @a[tag=plm_d_fire] run function plm:domains/fire/leave
scoreboard players reset #fire dm_run
scoreboard players set #fire dm_state 0
scoreboard players set #fire dm_deaths 0
scoreboard players remove #slots dm_party 1
forceload remove 256 0 351 31
kill @s
