advancement revoke @s only plm:domains/retreat_tower

execute unless entity @s[tag=plm_d_tower] run return 0
scoreboard players remove #tower dm_party 1
function plm:domains/tower/leave
