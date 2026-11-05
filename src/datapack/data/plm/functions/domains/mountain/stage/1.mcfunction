kill @e[tag=ds_prop_mountain]
scoreboard players set #mountain ds_stage 1
scoreboard players set #mountain ds_count 0
tellraw @a[tag=plm_d_mountain] {"text": "四象台 · 踩青龙坛剥去第一层。", "color": "gold"}
