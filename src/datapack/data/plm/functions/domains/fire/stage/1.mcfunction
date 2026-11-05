kill @e[tag=ds_prop_fire]
scoreboard players set #fire ds_stage 1
scoreboard players set #fire ds_count 0
tellraw @a[tag=plm_d_fire] {"text": "宴厅 · 击碎桌旁三件摆设", "color": "gold"}
setblock ~9 ~1 ~15 decorated_pot
summon interaction ~9.5 ~2 ~15.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar1_0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
setblock ~18 ~1 ~10 decorated_pot
summon interaction ~18.5 ~2 ~10.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar1_1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
setblock ~25 ~1 ~21 decorated_pot
summon interaction ~25.5 ~2 ~21.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar1_2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
