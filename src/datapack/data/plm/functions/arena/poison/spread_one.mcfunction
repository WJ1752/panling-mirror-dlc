# 老毒格重新排队，雷击清过的格子在出队时丢弃。
data modify storage plm:arena frontier append from entity @e[type=minecraft:marker,tag=mirror_arena_cursor,distance=..70,limit=1] Pos
function plm:arena/rand/1_4
execute if score #rng mirror_rand matches 1 positioned ~1 ~ ~ run function plm:arena/poison/spread_place
execute if score #rng mirror_rand matches 2 positioned ~-1 ~ ~ run function plm:arena/poison/spread_place
execute if score #rng mirror_rand matches 3 positioned ~ ~ ~1 run function plm:arena/poison/spread_place
execute if score #rng mirror_rand matches 4 positioned ~ ~ ~-1 run function plm:arena/poison/spread_place
