# 击杀事件初始化（@s=击杀玩家）
# 只负责“同一 tick 首次类型初始化”：清空 mirror_rub_type，随后各类型 advancement 按优先级写入。
# 同 tick 多杀无法区分击杀实体，类型按本 tick 已触发的最高优先级记录；加印不依赖本函数。
# mirror_rub_flag 仅作 tick 初始化标记，不再用于加印去重。
# 未持拓印镜炉（act:1）时不记录类型、不加印。
execute if score @s mirror_rub_flag = #sys mirror_game_time run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
scoreboard players operation @s mirror_rub_flag = #sys mirror_game_time
scoreboard players set @s mirror_rub_type 0
scoreboard players set @s mirror_rub_rubbable 0
