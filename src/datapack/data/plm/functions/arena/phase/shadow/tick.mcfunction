# 影主：不移动、不普攻；只做召唤计时（每秒处理）
execute if score #arena mirror_tick matches 10 at @e[tag=mirror_arena_boss,limit=1] run particle minecraft:enchant ~ ~1.5 ~ 0.4 0.6 0.4 0.2 2
