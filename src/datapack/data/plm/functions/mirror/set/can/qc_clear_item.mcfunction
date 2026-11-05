# 还原掉在地上的镜弩（item entity）：@s = item entity，Item.tag.mirror_qc3=1b。
# 只处理已掉落物；箱子/容器内的物品无法在 1.20.1 全局定位，交付文档列为已知限制。
scoreboard players set #qc_base mirror_skill_tmp3 0
execute store result score #qc_base mirror_skill_tmp3 run data get entity @s Item.tag.mirror_qc3_base
data remove entity @s Item.tag.Enchantments[{id:"minecraft:quick_charge"}]
execute if score #qc_base mirror_skill_tmp3 matches 1.. unless data entity @s Item.tag.Enchantments run data modify entity @s Item.tag.Enchantments set value []
execute if score #qc_base mirror_skill_tmp3 matches 1 run data modify entity @s Item.tag.Enchantments append value {id:"minecraft:quick_charge",lvl:1s}
execute if score #qc_base mirror_skill_tmp3 matches 2 run data modify entity @s Item.tag.Enchantments append value {id:"minecraft:quick_charge",lvl:2s}
execute if score #qc_base mirror_skill_tmp3 matches 3 run data modify entity @s Item.tag.Enchantments append value {id:"minecraft:quick_charge",lvl:3s}
execute unless data entity @s Item.tag.Enchantments[0] run data remove entity @s Item.tag.Enchantments
data remove entity @s Item.tag.mirror_qc3
data remove entity @s Item.tag.mirror_qc3_base
