advancement revoke @s only plm:domains/retreat_tomb

execute unless entity @s[tag=plm_d_tomb] run return 0
scoreboard players remove #tomb dm_party 1
function plm:domains/tomb/leave
