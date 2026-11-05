scoreboard players set #tomb ds_seq 2
scoreboard players set #tomb ds_window 0
scoreboard players set #tomb ds_hold 0
execute at @e[tag=ds_prop_tomb,limit=1] run setblock ~ ~-1 ~ soul_sand
tellraw @a[tag=plm_d_tomb] {"text":"空棺闭合。四角同亮并守住十秒。"}
