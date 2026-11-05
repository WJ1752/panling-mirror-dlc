advancement revoke @s only plm:domains/retreat_fire

execute unless entity @s[tag=plm_d_fire] run return 0
scoreboard players remove #fire dm_party 1
function plm:domains/fire/leave
