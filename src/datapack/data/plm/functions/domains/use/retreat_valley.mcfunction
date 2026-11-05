advancement revoke @s only plm:domains/retreat_valley

execute unless entity @s[tag=plm_d_valley] run return 0
scoreboard players remove #valley dm_party 1
function plm:domains/valley/leave
