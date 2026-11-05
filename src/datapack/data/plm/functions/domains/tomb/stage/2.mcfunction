kill @e[tag=ds_prop_tomb]
scoreboard players set #tomb ds_stage 2
scoreboard players set #tomb ds_count 0
tellraw @a[tag=plm_d_tomb] {"text": "石像长廊 · 点亮有脸石像，避开无面守卫。", "color": "gold"}
fill ~31 ~1 ~12 ~31 ~5 ~19 air
setblock ~37 ~1 ~10 chiseled_bookshelf
summon interaction ~37.5 ~2 ~10.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_box2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "烛匣 · 补充长明烛", "color": "gold"}'}
setblock ~38 ~1 ~8 candle
summon interaction ~38.5 ~2 ~8.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp2_0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~46 ~1 ~20 candle
summon interaction ~46.5 ~2 ~20.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp2_1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~55 ~1 ~9 candle
summon interaction ~55.5 ~2 ~9.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_lamp2_2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "点灯", "color": "gold"}'}
setblock ~48 ~1 ~8 polished_basalt
summon interaction ~48.5 ~2 ~8.5 {Tags:["dm_scene_tomb","ds_prop_tomb","ds_tomb_false_face"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "无面石像", "color": "gold"}'}
