scoreboard players operation #pct ds_hp = #mountain ds_hp
scoreboard players operation #pct ds_hp *= #100 ds_hp
scoreboard players operation #pct ds_hp /= #mountain ds_max
execute if score #pct ds_hp matches ..70 if score #mountain ds_hold matches 0 run scoreboard players set #mountain ds_hold 1
execute if score #pct ds_hp matches ..35 if score #mountain ds_hold matches 1 run function plm:domains/mountain/four
execute if score #mountain ds_hold matches ..1 run scoreboard players remove #cycle ds_clock 1
execute if score #cycle ds_clock matches 20 if score #mountain ds_hold matches 1 positioned ~80 ~1 ~15 run particle flame ~ ~ ~ 2 0.2 2 0 35
execute if score #cycle ds_clock matches 1 if score #mountain ds_hold matches 1 positioned ~80 ~1 ~15 as @a[tag=plm_d_mountain,distance=..4] run damage @s 5
execute if score #cycle ds_clock matches ..0 run function plm:domains/mountain/change
execute if score #stepped ds_count matches 2 if score #mountain ds_hold matches ..1 run scoreboard players set #mountain ds_window 100
execute if score #stepped ds_count matches 2 if score #mountain ds_hold matches 2 run scoreboard players add #mountain ds_count 1
execute if score #mountain ds_count matches 4.. run scoreboard players set #mountain ds_window 100
execute if score #stepped ds_count matches 1 if score #mountain ds_cd matches 0 run function plm:domains/mountain/wrong
