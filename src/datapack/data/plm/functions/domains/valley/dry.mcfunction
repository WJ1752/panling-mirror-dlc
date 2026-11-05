fill ~67 ~ ~4 ~72 ~ ~9 air
fill ~79 ~ ~4 ~84 ~ ~9 air
fill ~84 ~ ~20 ~89 ~ ~25 air
tp @e[tag=dm_boss_valley,limit=1] ~79.5 ~2 ~17.5
scoreboard players set #valley ds_window 0
scoreboard players set #valley ds_hold 2
tellraw @a[tag=plm_d_valley] {"text":"三池已干，右键中央主闸。"}
