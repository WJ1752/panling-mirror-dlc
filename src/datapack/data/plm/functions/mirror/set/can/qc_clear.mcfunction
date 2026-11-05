# 清理残留的临时 QC3：死亡/换维度/重登由 mirror/skill/clear 调用。
# 处理：当前主手、快捷栏 0..8、已掉落物；箱子/容器内无法全局定位（README 已知限制）。
# 先处理物品再清分数，qc_restore 需要 mirror_crossbow_4_bonus 作为兜底原始等级。
execute if data entity @s SelectedItem.tag.mirror_qc3 run function plm:mirror/set/can/qc_restore

kill @e[tag=mirror_qc_item_new]
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Tags:["mirror_qc_item_new"],Invisible:1b,Marker:1b,NoGravity:1b}

# 快捷栏 0..8：只写回确实带 mirror_qc3 标记的物品，避免清空空槽
item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.0
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.0 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.1
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.1 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.2
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.2 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.3
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.3 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.4
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.4 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.5
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.5 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.6
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.6 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.7
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.7 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

item replace entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand from entity @s hotbar.8
tag @e[tag=mirror_qc_item_new] remove mirror_qc_present
execute if data entity @e[tag=mirror_qc_item_new,limit=1] HandItems[0].tag.mirror_qc3 run tag @e[tag=mirror_qc_item_new,limit=1] add mirror_qc_present
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run function plm:mirror/set/can/qc_restore_temp
execute if entity @e[tag=mirror_qc_item_new,tag=mirror_qc_present] run item replace entity @s hotbar.8 from entity @e[tag=mirror_qc_item_new,limit=1] weapon.mainhand

kill @e[tag=mirror_qc_item_new]

# 已掉落物
execute as @e[type=item,nbt={Item:{tag:{mirror_qc3:1b}}}] run function plm:mirror/set/can/qc_clear_item

scoreboard players set @s mirror_crossbow_4_bonus 0
scoreboard players set @s mirror_crossbow_4_until 0
