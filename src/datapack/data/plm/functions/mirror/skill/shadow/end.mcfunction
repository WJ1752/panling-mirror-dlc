# 倒影结束：粒子 + 音效 + 移除
execute at @s run particle minecraft:end_rod ~ ~1 ~ 0.5 0.6 0.5 0.04 16
execute at @s run playsound minecraft:block.glass.break master @a ~ ~ ~ 0.6 1.5
kill @s
