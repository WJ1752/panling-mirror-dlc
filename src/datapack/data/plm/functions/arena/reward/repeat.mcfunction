data modify storage pld:system Temp_player_new_mails set value [{sent:"影域城镇",is_taked:0b,title:'{"text":"影主再战 · 倒影核"}',content:['{"text":"影主再次被击败，奖励已送达。"}'],attached_items:[{id:"minecraft:nautilus_shell",Count:1b,tag:{id:"panling:mirror_core",CustomModelData:410,display:{Name:'{"translate":"pl.item.name.mirror_core"}'}}}]}]
execute in minecraft:overworld run function pld:system/chest_menu/screen/3_mails/get_mails/personal
tellraw @s {"text":"影主已击败，个人邮箱已收到奖励。","color":"gold"}
