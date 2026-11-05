scoreboard players add #mountain ds_seq 1
scoreboard players operation #mountain ds_seq %= #four ds_seq
scoreboard players set #cycle ds_clock 300
execute if score #mountain ds_hold matches 1 run scoreboard players set #cycle ds_clock 200
