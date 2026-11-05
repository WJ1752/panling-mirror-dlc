# 合成本职业镜统：战 照心/裂影；弓 镜花/残影；丹 双生/拓印
function plm:weapon/util/rand100
scoreboard players set #t wp_mset 0
execute if score #t wp_form matches 1..2 if score #t wp_rand matches ..50 run scoreboard players set #t wp_mset 0
execute if score #t wp_form matches 1..2 if score #t wp_rand matches 51.. run scoreboard players set #t wp_mset 1
execute if score #t wp_form matches 3..4 if score #t wp_rand matches ..50 run scoreboard players set #t wp_mset 2
execute if score #t wp_form matches 3..4 if score #t wp_rand matches 51.. run scoreboard players set #t wp_mset 3
execute if score #t wp_form matches 5..6 if score #t wp_rand matches ..50 run scoreboard players set #t wp_mset 4
execute if score #t wp_form matches 5..6 if score #t wp_rand matches 51.. run scoreboard players set #t wp_mset 5
