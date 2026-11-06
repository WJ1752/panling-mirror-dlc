# 离线地形生成器已搭好镇区；此处只注册已加载镇区内的运行锚点。
function plm:shadow/town/markers

execute in minecraft:overworld if loaded -695 210 -1455 unless entity @e[type=text_display,tag=plm_shadow_label_market,limit=1] positioned -695.5 210 -1455.5 run summon text_display ~ ~ ~ {Tags:["plm_shadow_label_market"],billboard:"center",text:'{"text":"影商集市","color":"gray"}'}
execute in minecraft:overworld if loaded -710 210 -1455 unless entity @e[type=text_display,tag=plm_shadow_label_forge,limit=1] positioned -710.5 210 -1455.5 run summon text_display ~ ~ ~ {Tags:["plm_shadow_label_forge"],billboard:"center",text:'{"text":"磨镜工坊","color":"aqua"}'}
execute in minecraft:overworld if loaded -721 210 -1465 unless entity @e[type=text_display,tag=plm_shadow_label_inn,limit=1] positioned -721.5 210 -1465.5 run summon text_display ~ ~ ~ {Tags:["plm_shadow_label_inn"],billboard:"center",text:'{"text":"山门驿","color":"gray"}'}
execute in minecraft:overworld if loaded -720 218 -1443 unless entity @e[type=text_display,tag=plm_shadow_label_watch,limit=1] positioned -720.5 218 -1443.5 run summon text_display ~ ~ ~ {Tags:["plm_shadow_label_watch"],billboard:"center",text:'{"text":"守望钟楼","color":"dark_aqua"}'}
