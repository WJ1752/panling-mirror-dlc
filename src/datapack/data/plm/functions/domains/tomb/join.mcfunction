execute unless entity @s[tag=plm_seen_tomb] run tellraw @s {"text":"请先在对应的原版入口发现此域镜门。"}
execute unless entity @s[tag=plm_seen_tomb] run return 0
execute if entity @s[gamemode=spectator] run return 0
execute if entity @s[tag=plm_enrolled] run return 0
execute unless score @s dm_max_tomb matches 1.. run scoreboard players set @s dm_max_tomb 1
execute if score @s dm_depth > @s dm_max_tomb run tellraw @s {"text":"请先通关前一镜深。"}
execute if score @s dm_depth > @s dm_max_tomb run return 0
execute if score #tomb dm_state matches 2.. run tellraw @s {"text":"此域已有队伍挑战。"}
execute if score #tomb dm_state matches 2.. run return 0
execute if score #tomb dm_state matches 0 if score #slots dm_party matches 2.. run tellraw @s {"text":"两座镜域均已占用，请稍后再试。"}
execute if score #tomb dm_state matches 0 if score #slots dm_party matches 2.. run return 0
execute if score #tomb dm_state matches 0 run function plm:domains/tomb/reserve
execute unless score @s dm_depth = #tomb dm_depth run tellraw @s {"text":"本队镜深不同，请切换后报名。"}
execute unless score @s dm_depth = #tomb dm_depth run return 0
execute if score #tomb dm_party matches 4.. run tellraw @s {"text":"本队已满四人。"}
execute if score #tomb dm_party matches 4.. run return 0
tag @s add plm_d_tomb
tag @s add plm_enrolled
scoreboard players operation @s dm_run = #tomb dm_run
scoreboard players set @s dm_dead 0
scoreboard players set @s dm_leave 0
scoreboard players add #tomb dm_party 1
tellraw @s {"text":"已报名皇陵。请在重华台等候开门。"}
