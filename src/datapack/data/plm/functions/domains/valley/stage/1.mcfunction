kill @e[tag=ds_prop_valley]
scoreboard players set #valley ds_stage 1
scoreboard players set #valley ds_count 0
tellraw @a[tag=plm_d_valley] {"text": "干涸河床 · 右键第一道闸，观察水面。", "color": "gold"}
setblock ~9 ~1 ~13 cut_copper
summon interaction ~9.5 ~2 ~13.5 {Tags:["dm_scene_valley","ds_prop_valley","ds_valley_first"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "开第一闸", "color": "gold"}'}
