advancement revoke @s only plm:domains/map_mountain

tag @s add plm_seen_mountain
scoreboard players set @s dm_home 5
scoreboard players set @s dm_depth 1
execute in plm:domains run tp @s 25.5 64 13.5 180 0
tellraw @s {"text":"右键前方域门报名。五秒内可加入同域队伍。南侧门返回原地图。"}
