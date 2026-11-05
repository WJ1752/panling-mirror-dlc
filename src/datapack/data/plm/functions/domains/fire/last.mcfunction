scoreboard players set #fire ds_phase 3
scoreboard players set #fire ds_seq 0
scoreboard players set #fire ds_window 0
scoreboard players set #fire ds_hold 1
kill @e[tag=ds_prop_fire]
tellraw @a[tag=plm_d_fire] {"text":"最后的供品：依次砸冠、杯、旗，双心才会同时显形。"}
