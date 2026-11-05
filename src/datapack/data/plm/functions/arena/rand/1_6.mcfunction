# 1..6（0/7 重掷）
function plm:arena/rand/bits3
execute if score #rng mirror_rand matches 0 run function plm:arena/rand/1_6
execute if score #rng mirror_rand matches 7 run function plm:arena/rand/1_6
