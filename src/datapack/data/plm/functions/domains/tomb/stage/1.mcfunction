kill @e[tag=ds_prop_tomb]
scoreboard players set #tomb ds_stage 1
scoreboard players set #tomb ds_count 0
tellraw @a[tag=plm_d_tomb] {"text": "长明灯室 · 在烛匣取烛，再右键点亮三台。", "color": "gold"}
setblock ~5 ~1 ~10 chiseled_bookshelf
summon interaction ~5.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_box1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "烛匣 · 补充长明烛", "color": "gold"}'}
setblock ~10 ~1 ~9 candle
summon interaction ~10.5 ~2 ~9.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp1_0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~18 ~1 ~20 candle
summon interaction ~18.5 ~2 ~20.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp1_1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~25 ~1 ~10 candle
summon interaction ~25.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp1_2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
