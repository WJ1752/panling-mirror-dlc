scoreboard players set @s mirror_shadow_lord_done 1
scoreboard players operation @s mirror_arena_paid = #record mirror_arena_run
data modify storage pld:system Temp_player_new_mails set value [{sent:"影域城镇",is_taked:0b,title:'{"text":"影主首通 · 倒影核"}',content:['{"text":"你们击败了最终影主。首通纪念奖励已送达。"}'],attached_items:[{id:"minecraft:nautilus_shell",Count:2b,tag:{id:"panling:mirror_core",CustomModelData:410,display:{Name:'{"translate":"pl.item.name.mirror_core"}'}}}]}]
execute in minecraft:overworld run function pld:system/chest_menu/screen/3_mails/get_mails/personal
tellraw @s {"text":"影主首通完成，个人邮箱已收到首通奖励。","color":"gold"}
