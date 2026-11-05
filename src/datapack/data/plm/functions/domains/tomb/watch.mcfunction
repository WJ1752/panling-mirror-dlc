scoreboard players operation #pct ds_hp = #tomb ds_hp
scoreboard players operation #pct ds_hp *= #100 ds_hp
scoreboard players operation #pct ds_hp /= #tomb ds_max
execute if score #pct ds_hp matches ..70 if score #tomb ds_seq matches 0 run scoreboard players set #tomb ds_seq 1
execute if score #pct ds_hp matches ..35 if score #tomb ds_seq matches 1 run function plm:domains/tomb/last
execute if score #tomb ds_clock matches 40 as @e[tag=dm_boss_tomb,limit=1] at @s facing entity @p[tag=plm_d_tomb,distance=..25] feet positioned ^ ^ ^0.8 if block ~ ~ ~ air run tp @s ~ ~ ~
execute if score #tomb ds_seq matches 1 if score #tomb ds_cd matches 0 run function plm:domains/tomb/blow
execute if score #tomb ds_seq matches 1 if score #tomb ds_lamps matches 0 if score #tomb ds_clock matches 40 run scoreboard players add #tomb ds_hp 12
execute if score #tomb ds_seq matches 2 unless score #tomb ds_lamps matches 4 run scoreboard players set #tomb ds_hold 0
execute if score #tomb ds_seq matches 2 if score #tomb ds_lamps matches 4 run scoreboard players add #tomb ds_hold 1
execute if score #tomb ds_hold matches 200.. run scoreboard players set #tomb ds_window 20
