# 从 heart_fire 所在槽扣除 3 个
execute if score #t slot_heart_fire matches 0 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 0 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 0 if score #t tmp matches 1.. run function plm:mirror/table/take/set_0
execute if score #t slot_heart_fire matches 0 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
execute if score #t slot_heart_fire matches 1 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 1 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 1 if score #t tmp matches 1.. run function plm:mirror/table/take/set_1
execute if score #t slot_heart_fire matches 1 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:1b}]
execute if score #t slot_heart_fire matches 2 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 2 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 2 if score #t tmp matches 1.. run function plm:mirror/table/take/set_2
execute if score #t slot_heart_fire matches 2 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:2b}]
execute if score #t slot_heart_fire matches 3 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 3 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 3 if score #t tmp matches 1.. run function plm:mirror/table/take/set_3
execute if score #t slot_heart_fire matches 3 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:3b}]
execute if score #t slot_heart_fire matches 4 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 4 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 4 if score #t tmp matches 1.. run function plm:mirror/table/take/set_4
execute if score #t slot_heart_fire matches 4 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:4b}]
execute if score #t slot_heart_fire matches 5 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 5 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 5 if score #t tmp matches 1.. run function plm:mirror/table/take/set_5
execute if score #t slot_heart_fire matches 5 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:5b}]
execute if score #t slot_heart_fire matches 6 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 6 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 6 if score #t tmp matches 1.. run function plm:mirror/table/take/set_6
execute if score #t slot_heart_fire matches 6 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:6b}]
execute if score #t slot_heart_fire matches 7 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 7 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 7 if score #t tmp matches 1.. run function plm:mirror/table/take/set_7
execute if score #t slot_heart_fire matches 7 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:7b}]
execute if score #t slot_heart_fire matches 8 run scoreboard players operation #t tmp = #t num_heart_fire
execute if score #t slot_heart_fire matches 8 run scoreboard players remove #t tmp 3
execute if score #t slot_heart_fire matches 8 if score #t tmp matches 1.. run function plm:mirror/table/take/set_8
execute if score #t slot_heart_fire matches 8 if score #t tmp matches ..0 run data remove block ~ ~ ~ Items[{Slot:8b}]
