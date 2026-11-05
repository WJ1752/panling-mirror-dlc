scoreboard players operation @s dm_paid = @s dm_run
scoreboard players set @s dm_score 100
scoreboard players operation #penalty dm_score = #settle dm_deaths
scoreboard players operation #penalty dm_score *= #ten dm_score
scoreboard players operation @s dm_score -= #penalty dm_score
scoreboard players operation #late dm_score = #settle dm_age
scoreboard players remove #late dm_score 18000
scoreboard players operation #late dm_score /= #600 dm_score
scoreboard players operation #late dm_score *= #five dm_score
execute if score #late dm_score matches 1.. run scoreboard players operation @s dm_score -= #late dm_score
data modify storage pld:system Temp_player_new_mails set value [{sent:"重华台",is_taked:0b,title:'{"text":"炎巢 · 通关材料"}',content:['{"text":"镜片与影尘可在重华台影商兑换。"}'],attached_items:[{id:"minecraft:netherite_scrap",Count:10b,tag:{id:"panling:mirror_shard_fire",CustomModelData:315,display:{Name:'{"translate":"pl.item.name.mirror_shard_fire"}'}}},{id:"minecraft:gunpowder",Count:48b,tag:{id:"panling:mirror_dust",CustomModelData:390,display:{Name:'{"translate":"pl.item.name.mirror_dust"}'}}},{id:"minecraft:nautilus_shell",Count:2b,tag:{id:"panling:mirror_core",CustomModelData:410,display:{Name:'{"translate":"pl.item.name.mirror_core"}'}}},{id:"minecraft:glowstone_dust",Count:2b,tag:{id:"panling:mirror_sand",CustomModelData:391,display:{Name:'{"translate":"pl.item.name.mirror_sand"}'}}}]}]
execute if score @s dm_score matches 90.. run data modify storage pld:system Temp_player_new_mails[0].attached_items[0].Count set value 13b
execute if score @s dm_score matches 90.. run data modify storage pld:system Temp_player_new_mails[0].attached_items[1].Count set value 62b
execute if score @s dm_score matches 75..89 run data modify storage pld:system Temp_player_new_mails[0].attached_items[0].Count set value 11b
execute if score @s dm_score matches 75..89 run data modify storage pld:system Temp_player_new_mails[0].attached_items[1].Count set value 55b
execute if score @s dm_score matches ..54 run data modify storage pld:system Temp_player_new_mails[0].attached_items[0].Count set value 7b
execute if score @s dm_score matches ..54 run data modify storage pld:system Temp_player_new_mails[0].attached_items[1].Count set value 33b
execute in minecraft:overworld run function pld:system/chest_menu/screen/3_mails/get_mails/personal
execute if score @s dm_max_fire = #settle dm_depth if score @s dm_max_fire matches ..4 run scoreboard players add @s dm_max_fire 1
tag @s add plm_clear_fire
tellraw @s [{"text":"炎巢通关 · 镜评 "},{"score":{"name":"@s","objective":"dm_score"}},{"text":"。材料已寄个人邮箱。三枚同色镜片换镜心，影尘换镜片，倒影核换镜缘。"}]
