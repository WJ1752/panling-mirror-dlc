# 随机洗统的另一套（职业内 2 选 1）
execute if score #t wp_edge_set matches 0 run scoreboard players set #t wp_mset 1
execute if score #t wp_edge_set matches 1 run scoreboard players set #t wp_mset 0
execute if score #t wp_edge_set matches 2 run scoreboard players set #t wp_mset 3
execute if score #t wp_edge_set matches 3 run scoreboard players set #t wp_mset 2
execute if score #t wp_edge_set matches 4 run scoreboard players set #t wp_mset 5
execute if score #t wp_edge_set matches 5 run scoreboard players set #t wp_mset 4
