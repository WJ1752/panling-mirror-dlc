scoreboard players add @s ds_clock 1
particle flame ~ ~ ~ 1.2 0.1 1.2 0 8
execute if score @s ds_clock matches 20 as @a[tag=plm_d_fire,distance=..3] run damage @s 4 minecraft:on_fire
execute if score @s ds_clock matches 20.. run kill @s
