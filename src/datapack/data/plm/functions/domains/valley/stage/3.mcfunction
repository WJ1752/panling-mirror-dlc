kill @e[tag=ds_prop_valley]
scoreboard players set #valley ds_stage 3
scoreboard players set #valley ds_count 0
tellraw @a[tag=plm_d_valley] {"text": "泪神池 · 依次开西、北、东三闸；主池将出现倒影。", "color": "gold"}
fill ~63 ~1 ~12 ~63 ~5 ~19 air
setblock ~66 ~1 ~6 oxidized_copper
summon interaction ~66.5 ~2 ~6.5 {Tags:["dm_scene_valley","ds_prop_valley","ds_valley_pool0"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "西闸", "color": "gold"}'}
setblock ~78 ~1 ~6 oxidized_copper
summon interaction ~78.5 ~2 ~6.5 {Tags:["dm_scene_valley","ds_prop_valley","ds_valley_pool1"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "北闸", "color": "gold"}'}
setblock ~83 ~1 ~22 oxidized_copper
summon interaction ~83.5 ~2 ~22.5 {Tags:["dm_scene_valley","ds_prop_valley","ds_valley_pool2"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "东闸", "color": "gold"}'}
