# 副手拓印镜炉 Lore 写入（@s = 玩家）
# 有 Lore：覆盖末行（weapon/table/lore 预留的占位行）
# 无 Lore（旧物品/开发物品）：用 lore_init 建单行列表
execute if data entity @s Inventory[{Slot:-106b}].tag.display.Lore[0] run item modify entity @s weapon.offhand plm:mirror/skill/furnace/rub/lore_replace
execute unless data entity @s Inventory[{Slot:-106b}].tag.display.Lore[0] run item modify entity @s weapon.offhand plm:mirror/skill/furnace/rub/lore_init
