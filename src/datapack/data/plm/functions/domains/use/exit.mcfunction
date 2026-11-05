advancement revoke @s only plm:domains/exit
execute unless entity @s[tag=plm_enrolled] run function plm:domains/return_home
tellraw @s[tag=plm_enrolled] {"text":"已报名，请等候开门。"}
