# 拓印显影：3 格内白名单敌人发光 1s。
# 显影 = 原版 glowing（穿墙可见），与设计「显影」的语义一致。
execute at @s run effect give @e[tag=monster,distance=..3] minecraft:glowing 1 0 true
execute at @s run effect give @e[tag=mirror_boss,distance=..3] minecraft:glowing 1 0 true
execute at @s run effect give @e[tag=mirror_summon,distance=..3] minecraft:glowing 1 0 true
execute at @s run particle minecraft:dust 0.9 0.7 0.4 1 ~ ~1 ~ 1.2 0.6 1.2 0.02 20
