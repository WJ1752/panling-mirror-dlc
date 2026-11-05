# 分解返还影尘（槽 7，60%）
execute store result storage plm:weapon count int 1 run scoreboard players get #t wp_ret_dust
item replace block ~ ~ ~ container.7 with minecraft:gunpowder 1
data modify block ~ ~ ~ Items[{Slot:7b}].Count set from storage plm:weapon count
data modify block ~ ~ ~ Items[{Slot:7b}].tag set value {id:"panling:mirror_dust",CustomModelData:390,display:{Name:'{"text": "影尘", "color": "aqua", "italic": false}'}}
