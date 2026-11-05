# 延迟扫描：丢弃时 inventory_changed 先于 item entity 生成。
# 由 qc_drop_check schedule 2t 调用；执行源是服务端（没有 @s 玩家），只能做全局 item 扫描。
execute as @e[type=item,nbt={Item:{tag:{mirror_qc3:1b}}}] run function plm:mirror/set/can/qc_clear_item
