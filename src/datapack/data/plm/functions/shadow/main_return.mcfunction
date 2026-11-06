# @s为玩家。主城Overworld返程点同样必须有施工地板和两格净空。
scoreboard players set @s shadow_tp 0
execute in minecraft:overworld at @e[type=marker,tag=plm_shadow_main_return,limit=1] if block ~ ~-1 ~ #plm:shadow_landing_floor if block ~ ~ ~ minecraft:air if block ~ ~1 ~ minecraft:air store success score @s shadow_tp run tp @s ~ ~ ~
