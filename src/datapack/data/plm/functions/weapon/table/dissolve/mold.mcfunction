# 分解返还镜胚（槽 5）
execute if score #t wp_form matches 1 run item replace block ~ ~ ~ container.5 with minecraft:flint 1
execute if score #t wp_form matches 1 run data modify block ~ ~ ~ Items[{Slot:5b}].tag set value {id:"panling:mirror_mold_sword",CustomModelData:370,display:{Name:'{"text": "镜胚·剑", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 2 run item replace block ~ ~ ~ container.5 with minecraft:flint 1
execute if score #t wp_form matches 2 run data modify block ~ ~ ~ Items[{Slot:5b}].tag set value {id:"panling:mirror_mold_axe",CustomModelData:371,display:{Name:'{"text": "镜胚·斧", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 3 run item replace block ~ ~ ~ container.5 with minecraft:flint 1
execute if score #t wp_form matches 3 run data modify block ~ ~ ~ Items[{Slot:5b}].tag set value {id:"panling:mirror_mold_bow",CustomModelData:372,display:{Name:'{"text": "镜胚·弓", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 4 run item replace block ~ ~ ~ container.5 with minecraft:flint 1
execute if score #t wp_form matches 4 run data modify block ~ ~ ~ Items[{Slot:5b}].tag set value {id:"panling:mirror_mold_crossbow",CustomModelData:373,display:{Name:'{"text": "镜胚·弩", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 5 run item replace block ~ ~ ~ container.5 with minecraft:flint 1
execute if score #t wp_form matches 5 run data modify block ~ ~ ~ Items[{Slot:5b}].tag set value {id:"panling:mirror_mold_furnace_twin",CustomModelData:374,display:{Name:'{"text": "镜胚·双生炉", "color": "aqua", "italic": false}'}}
execute if score #t wp_form matches 6 run item replace block ~ ~ ~ container.5 with minecraft:flint 1
execute if score #t wp_form matches 6 run data modify block ~ ~ ~ Items[{Slot:5b}].tag set value {id:"panling:mirror_mold_furnace_rub",CustomModelData:375,display:{Name:'{"text": "镜胚·拓印炉", "color": "aqua", "italic": false}'}}
