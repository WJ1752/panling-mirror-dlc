kill @e[tag=ds_prop_tomb]
scoreboard players set #tomb ds_stage 3
scoreboard players set #tomb ds_count 0
tellraw @a[tag=plm_d_tomb] {"text": "空棺 · 点亮棺角四灯。", "color": "gold"}
fill ~63 ~1 ~12 ~63 ~5 ~19 air
setblock ~69 ~1 ~10 chiseled_bookshelf
summon interaction ~69.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_box3"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "烛匣 · 补充长明烛", "color": "gold"}'}
setblock ~73 ~1 ~10 candle
summon interaction ~73.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp3_0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~85 ~1 ~10 candle
summon interaction ~85.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp3_1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~85 ~1 ~21 candle
summon interaction ~85.5 ~2 ~21.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp3_2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~73 ~1 ~21 candle
summon interaction ~73.5 ~2 ~21.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp3_3"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
