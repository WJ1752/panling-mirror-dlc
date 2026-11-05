function plm:domains/tomb/cleanup
execute as @a[tag=plm_d_tomb] run function plm:domains/tomb/leave
scoreboard players reset #tomb dm_run
scoreboard players set #tomb dm_state 0
scoreboard players set #tomb dm_deaths 0
scoreboard players remove #slots dm_party 1
forceload remove 512 0 607 31
kill @s
