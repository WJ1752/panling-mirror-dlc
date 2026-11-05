fill 0 63 0 31 63 31 polished_deepslate
fill 0 64 0 31 64 0 polished_blackstone_bricks
fill 0 64 31 31 64 31 polished_blackstone_bricks
fill 0 64 1 0 64 30 polished_blackstone_bricks
fill 31 64 1 31 64 30 polished_blackstone_bricks
setblock 21 64 6 ender_chest
fill 2 63 14 29 63 16 sea_lantern
setblock 14 64 6 dropper[facing=up]
execute positioned 18 64 6 run function plm:mirror/hub/merchant
data merge entity @e[type=villager,tag=plm_merchant,x=18,y=64,z=6,distance=..2,limit=1] {NoAI:1b,Invulnerable:1b,PersistenceRequired:1b}
summon interaction 15.5 64 6.5 {Tags:["plm_gate_work"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "磨镜台 · 放料后右键", "color": "aqua"}'}]}
summon interaction 16.5 64 25.5 {Tags:["plm_gate_exit"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "返回来时的入口", "color": "aqua"}'}]}
summon interaction 10.5 64 8.5 {Tags:["plm_gate_depth"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "切换镜深 Ⅰ–Ⅴ", "color": "aqua"}'}]}
setblock 5 63 10 amethyst_block
summon interaction 5.5 64 10.5 {Tags:["plm_gate_join_fire"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "炎巢 · 报名", "color": "aqua"}'}]}
setblock 10 63 10 amethyst_block
summon interaction 10.5 64 10.5 {Tags:["plm_gate_join_tomb"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "皇陵 · 报名", "color": "aqua"}'}]}
setblock 15 63 10 amethyst_block
summon interaction 15.5 64 10.5 {Tags:["plm_gate_join_tower"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "妖塔 · 报名", "color": "aqua"}'}]}
setblock 20 63 10 amethyst_block
summon interaction 20.5 64 10.5 {Tags:["plm_gate_join_valley"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "泪谷 · 报名", "color": "aqua"}'}]}
setblock 25 63 10 amethyst_block
summon interaction 25.5 64 10.5 {Tags:["plm_gate_join_mountain"],width:1.6f,height:2.2f,response:1b,Passengers:[{id:"minecraft:text_display",billboard:"center",alignment:"center",transformation:{translation:[0f,0.5f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},text:'{"text": "圣山 · 报名", "color": "aqua"}'}]}
summon marker 16 64 16 {Tags:["plm_hub"]}
