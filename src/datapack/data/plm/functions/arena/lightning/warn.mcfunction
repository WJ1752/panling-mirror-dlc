scoreboard players set #arena mirror_lightning_timer 5
kill @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1]
execute as @a[tag=mirror_arena_inside,distance=0..,sort=random,limit=1] at @s align xz run function plm:arena/lightning/warn/pick
