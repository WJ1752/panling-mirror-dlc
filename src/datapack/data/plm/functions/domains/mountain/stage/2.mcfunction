kill @e[tag=ds_prop_mountain]
scoreboard players set #mountain ds_stage 2
scoreboard players set #mountain ds_count 0
tellraw @a[tag=plm_d_mountain] {"text": "双象台 · 沿光柱踩两坛，避开候场兽的预警。", "color": "gold"}
fill ~31 ~1 ~12 ~31 ~5 ~19 air
