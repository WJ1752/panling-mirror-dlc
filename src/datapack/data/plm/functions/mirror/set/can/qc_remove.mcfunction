# 还原到“原本没有 Quick Charge”：移除该附魔后写回
kill @e[tag=mirror_qc_item_new]
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Tags:["mirror_qc_item_new"],Invisible:1b,Marker:1b,NoGravity:1b}
item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s weapon.mainhand
data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments[{id:"minecraft:quick_charge"}]
# 原本没有附魔时不要把空 Enchantments 列表留在物品上
execute unless data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments[0] run data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments
data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3
data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3_base
item replace entity @s weapon.mainhand from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand
kill @e[tag=mirror_qc_item_new]
