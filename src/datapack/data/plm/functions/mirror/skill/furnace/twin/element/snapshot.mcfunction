# 主阵元素快照：@s = 玩家，输出 @s mirror_zf_el（1 金 / 2 木 / 3 水 / 4 火 / 5 土，0=没有元素）
# 输入 #tw_hand mirror_zf_tmp：1 = 元素在主手（炉副手），-1 = 元素在副手（炉主手）
# 精炼/浓缩元素沿用本体 id（panling:refined_* / panling:again_refined_*），同属一个元素。
# 读取方式与本体 pld:mainhand|offhand 的 predicate 一致，不用 data get 物品。

# ---- 主手（炉在副手，after_main）----
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:metal"}}}] run scoreboard players set @s mirror_zf_el 1
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:refined_metal"}}}] run scoreboard players set @s mirror_zf_el 1
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:again_refined_metal"}}}] run scoreboard players set @s mirror_zf_el 1
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:wood"}}}] run scoreboard players set @s mirror_zf_el 2
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:refined_wood"}}}] run scoreboard players set @s mirror_zf_el 2
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:again_refined_wood"}}}] run scoreboard players set @s mirror_zf_el 2
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:water"}}}] run scoreboard players set @s mirror_zf_el 3
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:refined_water"}}}] run scoreboard players set @s mirror_zf_el 3
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:again_refined_water"}}}] run scoreboard players set @s mirror_zf_el 3
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:fire"}}}] run scoreboard players set @s mirror_zf_el 4
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:refined_fire"}}}] run scoreboard players set @s mirror_zf_el 4
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:again_refined_fire"}}}] run scoreboard players set @s mirror_zf_el 4
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:earth"}}}] run scoreboard players set @s mirror_zf_el 5
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:refined_earth"}}}] run scoreboard players set @s mirror_zf_el 5
execute if score #tw_hand mirror_zf_tmp matches 1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:again_refined_earth"}}}] run scoreboard players set @s mirror_zf_el 5

# ---- 副手（炉在主手，after_off / 镜匣）----
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:metal"}}]}] run scoreboard players set @s mirror_zf_el 1
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:refined_metal"}}]}] run scoreboard players set @s mirror_zf_el 1
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:again_refined_metal"}}]}] run scoreboard players set @s mirror_zf_el 1
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:wood"}}]}] run scoreboard players set @s mirror_zf_el 2
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:refined_wood"}}]}] run scoreboard players set @s mirror_zf_el 2
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:again_refined_wood"}}]}] run scoreboard players set @s mirror_zf_el 2
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:water"}}]}] run scoreboard players set @s mirror_zf_el 3
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:refined_water"}}]}] run scoreboard players set @s mirror_zf_el 3
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:again_refined_water"}}]}] run scoreboard players set @s mirror_zf_el 3
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:fire"}}]}] run scoreboard players set @s mirror_zf_el 4
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:refined_fire"}}]}] run scoreboard players set @s mirror_zf_el 4
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:again_refined_fire"}}]}] run scoreboard players set @s mirror_zf_el 4
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:earth"}}]}] run scoreboard players set @s mirror_zf_el 5
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:refined_earth"}}]}] run scoreboard players set @s mirror_zf_el 5
execute if score #tw_hand mirror_zf_tmp matches -1 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:again_refined_earth"}}]}] run scoreboard players set @s mirror_zf_el 5
