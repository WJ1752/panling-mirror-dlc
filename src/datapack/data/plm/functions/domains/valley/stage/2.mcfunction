kill @e[tag=ds_prop_valley]
scoreboard players set #valley ds_stage 2
scoreboard players set #valley ds_count 0
tellraw @a[tag=plm_d_valley] {"text": "倒置祭坛 · 开闸后击碎水中倒影，显影三次。", "color": "gold"}
fill ~31 ~1 ~12 ~31 ~5 ~19 air
setblock ~43 ~1 ~14 cut_copper
summon interaction ~43.5 ~2 ~14.5 {Tags:["dm_scene_valley","ds_prop_valley","ds_valley_altar"],width:1.4f,height:1.6f,response:1b,CustomNameVisible:1b,CustomName:'{"text": "祭坛闸 · 灌水", "color": "gold"}'}
