kill @e[tag=ds_prop_fire]
scoreboard players set #fire ds_stage 3
scoreboard players set #fire ds_count 0
tellraw @a[tag=plm_d_fire] {"text": "王座 · 击碎冠、杯、旗", "color": "gold"}
fill ~63 ~1 ~12 ~63 ~5 ~19 air
setblock ~72 ~1 ~11 gilded_blackstone
summon interaction ~72.5 ~2 ~11.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar3_0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "冠", "color": "gold"}'}
setblock ~78 ~1 ~21 flower_pot
summon interaction ~78.5 ~2 ~21.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar3_1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "杯", "color": "gold"}'}
setblock ~85 ~1 ~11 red_banner
summon interaction ~85.5 ~2 ~11.5 {Tags:["dm_scene_fire","ds_prop_fire","ds_fire_jar3_2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "旗", "color": "gold"}'}
