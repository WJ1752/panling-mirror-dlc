# 在 8 个刷怪点里随机选一个
execute at @e[tag=mirror_spawn,tag=mirror_arena_point,distance=..36,sort=random,limit=1] run function plm:arena/summon/spawn_here
