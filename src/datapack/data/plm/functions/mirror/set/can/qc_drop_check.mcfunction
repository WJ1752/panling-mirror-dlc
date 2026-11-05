# 玩家丢弃/拾取物品后：附近掉落的临时 QC3 立即还原，不必等下一次死亡/换维度 clear。
# 由 advancement plm:mirror/can/qc_inventory（inventory_changed）调用；@s=玩家。
# 1.20.1 没有 player_drop_item 触发器，只能用 inventory_changed + 附近 item entity 扫描。
advancement revoke @s only plm:mirror/can/qc_inventory
execute as @e[type=item,nbt={Item:{tag:{mirror_qc3:1b}}},distance=..8] run function plm:mirror/set/can/qc_clear_item
# 丢弃时 inventory_changed 先于 item entity 生成；1t 后再做一次全局扫描。
schedule function plm:mirror/set/can/qc_drop_check_late 2t replace
# 拾取后 buff 已结束的残留：主手带标记且没有活跃 buff 时还原
execute if data entity @s SelectedItem.tag.mirror_qc3 unless score @s mirror_crossbow_4_bonus matches 100.. run function plm:mirror/set/can/qc_clear
