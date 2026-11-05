# 1..46（0..45；0..63 中 47..63 重掷）
function plm:arena/rand/bits6
execute if score #rng mirror_rand matches 46..63 run function plm:arena/rand/1_46
execute if score #rng mirror_rand matches 0..45 run scoreboard players add #rng mirror_rand 1
