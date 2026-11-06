# 地标坐标来自src/tools/shadow_layout.json；地表与地下marker分离，等区块可读后重试。
execute in minecraft:overworld if loaded -704 206 -1450 unless entity @e[type=marker,tag=plm_shadow_town_return,limit=1] run summon marker -703.5 206 -1449.5 {Tags:["plm_shadow_town_return"]}
execute in minecraft:overworld if loaded -712 208 -1442 unless entity @e[type=marker,tag=plm_shadow_arena_portal_point,limit=1] run summon marker -711.5 208 -1441.5 {Tags:["plm_shadow_arena_portal_point"]}
execute in minecraft:overworld if loaded -712 -40 -1442 unless entity @e[type=marker,tag=plm_shadow_arena_center,limit=1] run summon marker -711.5 -40 -1441.5 {Tags:["plm_shadow_arena_center"]}
execute in minecraft:overworld if loaded -701 206 -1455 unless entity @e[type=marker,tag=plm_shadow_merchant_spot,limit=1] run summon marker -700.5 206 -1454.5 {Tags:["plm_shadow_merchant_spot"]}
execute in minecraft:overworld if loaded -708 205 -1456 unless entity @e[type=marker,tag=plm_shadow_forge,limit=1] run summon marker -707.5 205.5 -1455.5 {Tags:["plm_shadow_forge"]}
execute in minecraft:overworld if loaded -707 206 -1449 unless entity @e[type=marker,tag=plm_shadow_guide_spot,limit=1] run summon marker -706.5 206 -1448.5 {Tags:["plm_shadow_guide_spot"]}
execute in minecraft:overworld if loaded -701 206 -1449 unless entity @e[type=marker,tag=plm_shadow_exit_spot,limit=1] run summon marker -700.5 206 -1448.5 {Tags:["plm_shadow_exit_spot"]}
