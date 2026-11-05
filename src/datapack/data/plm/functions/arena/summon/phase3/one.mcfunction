function plm:arena/rand/1_3
scoreboard players operation #arena mirror_summon_type = #rng mirror_rand
execute at @e[tag=mirror_spawn,tag=mirror_arena_point,distance=..36,sort=random,limit=1] run function plm:arena/summon/phase3/spawn_here
