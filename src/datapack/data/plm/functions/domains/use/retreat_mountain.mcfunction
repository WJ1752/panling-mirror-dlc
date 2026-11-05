advancement revoke @s only plm:domains/retreat_mountain

execute unless entity @s[tag=plm_d_mountain] run return 0
scoreboard players remove #mountain dm_party 1
function plm:domains/mountain/leave
