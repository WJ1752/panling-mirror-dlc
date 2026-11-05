# 留影 · 清除镜弩的 Multishot（保留 Quick Charge II）
# 背景：本体 equipment_lock/enable/main:12 会给除 panling:crossbow5 外的所有弩追加 multishot 1。
# 1.20.1 的 /data 不能修改玩家数据（实测 "Unable to modify player data"），
# 所以用临时 armor_stand 当容器：复制主手 -> 改 stand 的 HandItems[0] -> 复制回主手。
# 只在镜像 SelectedItem 里确实有 multishot 时执行，避免每 5t 反复写坏物品。
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
scoreboard players set #has mirror_skill_tmp 0
execute store result score #has mirror_skill_tmp run data get entity @s SelectedItem.tag.Enchantments[{id:"minecraft:multishot"}]
execute if score #has mirror_skill_tmp matches 0 run return 0

execute at @s run summon minecraft:armor_stand ~ ~ ~ {Tags:["mirror_crossbow_item_new"],Invisible:1b,Marker:1b,NoGravity:1b}
item replace entity @e[tag=mirror_crossbow_item_new,limit=1] weapon.mainhand from entity @s weapon.mainhand
data remove entity @e[tag=mirror_crossbow_item_new,limit=1] HandItems[0].tag.Enchantments[{id:"minecraft:multishot"}]
item replace entity @s weapon.mainhand from entity @e[tag=mirror_crossbow_item_new,limit=1] weapon.mainhand
kill @e[tag=mirror_crossbow_item_new]
