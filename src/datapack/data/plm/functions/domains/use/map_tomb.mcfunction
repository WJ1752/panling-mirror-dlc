advancement revoke @s only plm:domains/map_tomb

tag @s add plm_seen_tomb
scoreboard players set @s dm_home 2
scoreboard players set @s dm_depth 1
execute in plm:domains run tp @s 10.5 64 13.5 180 0
tellraw @s {"text":"右键前方域门报名。五秒内可加入同域队伍。南侧门返回原地图。"}
