execute if data entity @s {Health:0.0f} run tag @s add plm_hub_respawn
tag @s remove plm_d_mountain
tag @s remove plm_rescue
tag @s remove plm_enrolled
execute if entity @s[tag=plm_was_survival] run gamemode survival @s
tag @s remove plm_was_survival
execute in plm:domains run tp @s 16.5 64 16.5 180 0
