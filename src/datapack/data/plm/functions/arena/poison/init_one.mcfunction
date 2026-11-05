# rand/1_46 产生房间内原坐标 1..46；先加实际锚点再写游标。
tp @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] ~ ~ ~
function plm:arena/rand/1_46
scoreboard players remove #rng mirror_rand 24
execute store result score #arena mirror_tmp run data get entity @e[type=minecraft:marker,tag=mirror_arena_anchor,distance=..70,limit=1] Pos[0]
scoreboard players operation #rng mirror_rand += #arena mirror_tmp
execute store result entity @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] Pos[0] double 1 run scoreboard players get #rng mirror_rand
function plm:arena/rand/1_46
scoreboard players remove #rng mirror_rand 24
execute store result score #arena mirror_tmp run data get entity @e[type=minecraft:marker,tag=mirror_arena_anchor,distance=..70,limit=1] Pos[2]
scoreboard players operation #rng mirror_rand += #arena mirror_tmp
execute store result entity @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] Pos[2] double 1 run scoreboard players get #rng mirror_rand
execute at @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] run function plm:arena/poison/spread_place
