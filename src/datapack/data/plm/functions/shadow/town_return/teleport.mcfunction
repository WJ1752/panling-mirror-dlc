# @s为玩家。返程必须落在地图提供的两格普通空气镇落点和已施工地板上。
scoreboard players set @s shadow_tp 0
execute in minecraft:overworld at @e[type=marker,tag=plm_shadow_town_return,limit=1] if block ~ ~-1 ~ #plm:shadow_landing_floor if block ~ ~ ~ minecraft:air if block ~ ~1 ~ minecraft:air store success score @s shadow_tp run tp @s ~ ~ ~
