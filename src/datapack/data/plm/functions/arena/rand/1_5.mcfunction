# 1..5
function plm:arena/rand/bits3
execute if score #rng mirror_rand matches 5..7 run function plm:arena/rand/1_5
execute if score #rng mirror_rand matches 0..4 run scoreboard players add #rng mirror_rand 1
