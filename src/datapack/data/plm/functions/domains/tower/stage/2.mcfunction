kill @e[tag=ds_prop_tower]
scoreboard players set #tower ds_stage 2
scoreboard players set #tower ds_count 0
tellraw @a[tag=plm_d_tower] {"text": "断塔竖井 · 裂纹后方会崩塌，贴南侧窄边可追赶。", "color": "gold"}
fill ~31 ~1 ~12 ~31 ~5 ~19 air
