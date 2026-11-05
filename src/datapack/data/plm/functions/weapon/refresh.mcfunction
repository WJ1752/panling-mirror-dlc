# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 事件驱动的重解析：由 activation、WeaponSlot 变化、镜武 inventory_changed 触发。
# 本函数自己不做周期性节流；tick/refresh 只在槽位变化时调用它。
data modify storage plm:weapon item set value {}
execute if score @s WeaponSlot matches 1 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:0b}]
execute if score @s WeaponSlot matches 2 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:1b}]
execute if score @s WeaponSlot matches 3 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:2b}]
execute if score @s WeaponSlot matches 4 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:3b}]
execute if score @s WeaponSlot matches 5 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:4b}]
execute if score @s WeaponSlot matches 6 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:5b}]
execute if score @s WeaponSlot matches 7 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:6b}]
execute if score @s WeaponSlot matches 8 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:7b}]
execute if score @s WeaponSlot matches 9 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:8b}]
execute if score @s WeaponSlot matches -1 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:-106b}]
execute unless score @s WeaponSlot matches -1..9 run data modify storage plm:weapon item set from entity @s SelectedItem
execute unless data storage plm:weapon item.tag{mirror:1,act:1} run function plm:weapon/clear
execute if data storage plm:weapon item.tag{mirror:1,act:1} run function plm:weapon/parse/apply
# 记录已解析的槽位；下次 tick/refresh 只有 WeaponSlot 变化才重解析。
execute if score @s WeaponSlot matches -2147483648.. run scoreboard players operation @s mirror_last_wslot = @s WeaponSlot
