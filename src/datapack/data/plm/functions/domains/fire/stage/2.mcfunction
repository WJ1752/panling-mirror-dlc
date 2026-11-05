kill @e[tag=ds_prop_fire]
scoreboard players set #fire ds_stage 2
scoreboard players set #fire ds_count 0
tellraw @a[tag=plm_d_fire] {"text": "酒窖 · 击碎五坛后绕柱避开火环", "color": "gold"}
fill ~31 ~1 ~12 ~31 ~5 ~19 air
setblock ~36 ~1 ~8 decorated_pot
summon interaction ~36.5 ~2 ~8.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar2_0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
setblock ~40 ~1 ~22 decorated_pot
summon interaction ~40.5 ~2 ~22.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar2_1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
setblock ~46 ~1 ~8 decorated_pot
summon interaction ~46.5 ~2 ~8.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar2_2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
setblock ~51 ~1 ~22 decorated_pot
summon interaction ~51.5 ~2 ~22.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar2_3"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
setblock ~57 ~1 ~8 decorated_pot
summon interaction ~57.5 ~2 ~8.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar2_4"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "击碎 · 酒坛", "color": "gold"}'}
