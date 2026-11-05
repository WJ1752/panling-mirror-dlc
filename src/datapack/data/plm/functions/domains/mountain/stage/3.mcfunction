kill @e[tag=ds_prop_mountain]
scoreboard players set #mountain ds_stage 3
scoreboard players set #mountain ds_count 0
tellraw @a[tag=plm_d_mountain] {"text": "圣山顶 · 循地纹依次踏过四座祭坛。", "color": "gold"}
fill ~63 ~1 ~12 ~63 ~5 ~19 air
