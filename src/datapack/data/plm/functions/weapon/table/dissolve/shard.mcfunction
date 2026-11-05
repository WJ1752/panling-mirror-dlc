# 分解返还镜片（槽 6，60%，至少 2）
execute store result storage plm:weapon count int 1 run scoreboard players get #t wp_ret_shard
execute if score #t wp_form matches 1 run item replace block ~ ~ ~ container.6 with minecraft:netherite_scrap 1
execute if score #t wp_form matches 1 run data modify block ~ ~ ~ Items[{Slot:6b}].Count set from storage plm:weapon count
execute if score #t wp_form matches 1 run data modify block ~ ~ ~ Items[{Slot:6b}].tag set value {id:"panling:mirror_shard_metal",CustomModelData:300,display:{Name:'{"text": "镜片·金", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 2 run item replace block ~ ~ ~ container.6 with minecraft:netherite_scrap 1
execute if score #t wp_form matches 2 run data modify block ~ ~ ~ Items[{Slot:6b}].Count set from storage plm:weapon count
execute if score #t wp_form matches 2 run data modify block ~ ~ ~ Items[{Slot:6b}].tag set value {id:"panling:mirror_shard_fire",CustomModelData:315,display:{Name:'{"text": "镜片·火", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 3 run item replace block ~ ~ ~ container.6 with minecraft:netherite_scrap 1
execute if score #t wp_form matches 3 run data modify block ~ ~ ~ Items[{Slot:6b}].Count set from storage plm:weapon count
execute if score #t wp_form matches 3 run data modify block ~ ~ ~ Items[{Slot:6b}].tag set value {id:"panling:mirror_shard_water",CustomModelData:310,display:{Name:'{"text": "镜片·水", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 4 run item replace block ~ ~ ~ container.6 with minecraft:netherite_scrap 1
execute if score #t wp_form matches 4 run data modify block ~ ~ ~ Items[{Slot:6b}].Count set from storage plm:weapon count
execute if score #t wp_form matches 4 run data modify block ~ ~ ~ Items[{Slot:6b}].tag set value {id:"panling:mirror_shard_wood",CustomModelData:305,display:{Name:'{"text": "镜片·木", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 5 run item replace block ~ ~ ~ container.6 with minecraft:netherite_scrap 1
execute if score #t wp_form matches 5 run data modify block ~ ~ ~ Items[{Slot:6b}].Count set from storage plm:weapon count
execute if score #t wp_form matches 5 run data modify block ~ ~ ~ Items[{Slot:6b}].tag set value {id:"panling:mirror_shard_fire",CustomModelData:315,display:{Name:'{"text": "镜片·火", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 6 run item replace block ~ ~ ~ container.6 with minecraft:netherite_scrap 1
execute if score #t wp_form matches 6 run data modify block ~ ~ ~ Items[{Slot:6b}].Count set from storage plm:weapon count
execute if score #t wp_form matches 6 run data modify block ~ ~ ~ Items[{Slot:6b}].tag set value {id:"panling:mirror_shard_earth",CustomModelData:320,display:{Name:'{"text": "镜片·土", "color": "aqua", "italic": false}'}}
