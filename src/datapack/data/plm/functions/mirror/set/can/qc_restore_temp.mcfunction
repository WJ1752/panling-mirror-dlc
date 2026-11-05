# 把临时 armor_stand 主手里的镜弩 QC3 还原到 mirror_qc3_base，并摘掉清理标记。
# @s = armor_stand；调用前物品已复制到 HandItems[0]。
scoreboard players set #qc_base mirror_skill_tmp3 0
execute store result score #qc_base mirror_skill_tmp3 run data get entity @s HandItems[0].tag.mirror_qc3_base
# 原始没有 QC 时 base 缺失 → 保持 0
data remove entity @s HandItems[0].tag.Enchantments[{id:"minecraft:quick_charge"}]
execute if score #qc_base mirror_skill_tmp3 matches 1.. unless data entity @s HandItems[0].tag.Enchantments run data modify entity @s HandItems[0].tag.Enchantments set value []
execute if score #qc_base mirror_skill_tmp3 matches 1 run data modify entity @s HandItems[0].tag.Enchantments append value {id:"minecraft:quick_charge",lvl:1s}
execute if score #qc_base mirror_skill_tmp3 matches 2 run data modify entity @s HandItems[0].tag.Enchantments append value {id:"minecraft:quick_charge",lvl:2s}
execute if score #qc_base mirror_skill_tmp3 matches 3 run data modify entity @s HandItems[0].tag.Enchantments append value {id:"minecraft:quick_charge",lvl:3s}
execute unless data entity @s HandItems[0].tag.Enchantments[0] run data remove entity @s HandItems[0].tag.Enchantments
data remove entity @s HandItems[0].tag.mirror_qc3
data remove entity @s HandItems[0].tag.mirror_qc3_base
