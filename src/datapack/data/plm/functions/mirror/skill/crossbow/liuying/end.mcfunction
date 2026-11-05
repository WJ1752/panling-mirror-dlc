# 留影 · 弩机结束（@s=弩机）
execute at @s run particle minecraft:dust 0.55 0.25 0.95 1.0 ~ ~1 ~ 0.5 0.6 0.5 0 16
execute at @s run playsound minecraft:block.glass.break master @a ~ ~ ~ 0.6 1.5
kill @s
