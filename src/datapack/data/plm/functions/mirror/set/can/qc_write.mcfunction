# 用临时 armor_stand 复制主手物品，改 Quick Charge 后写回（1.20.1 不能 /data modify player）
# 输入：@s=玩家，#qc_lvl mirror_skill_tmp2 = 目标等级 1..3；
#       #qc_mark mirror_skill_tmp3 = 1 表示这是“施加临时 QC3”，要在物品上留可清理标记。
# 物品标记：mirror_qc3:1b + mirror_qc3_base:<原始等级>，供死亡/丢弃/换手持时还原。
kill @e[tag=mirror_qc_item_new]
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Tags:["mirror_qc_item_new"],Invisible:1b,Marker:1b,NoGravity:1b}
item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s weapon.mainhand

# 原始等级来自 mirror_crossbow_4_bonus（100+原始等级）；缺失时按 0 处理
scoreboard players set #qc_base mirror_skill_tmp3 0
scoreboard players operation #qc_base mirror_skill_tmp3 = @s mirror_crossbow_4_bonus
scoreboard players remove #qc_base mirror_skill_tmp3 100
execute if score #qc_base mirror_skill_tmp3 matches ..-1 run scoreboard players set #qc_base mirror_skill_tmp3 0

execute unless data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments run data modify entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments set value []
data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments[{id:"minecraft:quick_charge"}]
execute if score #qc_lvl mirror_skill_tmp2 matches 1 run data modify entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments append value {id:"minecraft:quick_charge",lvl:1s}
execute if score #qc_lvl mirror_skill_tmp2 matches 2 run data modify entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments append value {id:"minecraft:quick_charge",lvl:2s}
execute if score #qc_lvl mirror_skill_tmp2 matches 3 run data modify entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.Enchantments append value {id:"minecraft:quick_charge",lvl:3s}

# 施加时打标记；还原时摘标记
execute if score #qc_mark mirror_skill_tmp3 matches 1 run data modify entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 set value 1b
execute if score #qc_mark mirror_skill_tmp3 matches 1 run execute store result entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3_base byte 1 run scoreboard players get #qc_base mirror_skill_tmp3
execute if score #qc_mark mirror_skill_tmp3 matches 0 run data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3
execute if score #qc_mark mirror_skill_tmp3 matches 0 run data remove entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3_base

item replace entity @s weapon.mainhand from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand
kill @e[tag=mirror_qc_item_new]
