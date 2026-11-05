scoreboard players add @s ds_clock 1
particle ash ~ ~1 ~ 0.3 0.4 0.3 0 3
execute if score @s ds_clock matches 45.. unless data entity @s {Health:0.0f} run setblock ~ ~-1 ~ soul_sand
execute if score @s ds_clock matches 45.. run kill @s
