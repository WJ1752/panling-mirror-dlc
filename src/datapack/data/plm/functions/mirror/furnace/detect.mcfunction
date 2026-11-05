# 挂在 #pld:zf/zfmain（本体检测完原版炉之后）
# 主手镜炉 → zf_hold_ldl=-4；副手镜炉 → +4
# 先写副手再写主手，双手都是炉时主手优先
execute if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_twin7"}}]}] run scoreboard players set @s zf_hold_ldl 4
execute if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7"}}]}] run scoreboard players set @s zf_hold_ldl 4
execute if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_twin7"}}}] run scoreboard players set @s zf_hold_ldl -4
execute if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7"}}}] run scoreboard players set @s zf_hold_ldl -4
