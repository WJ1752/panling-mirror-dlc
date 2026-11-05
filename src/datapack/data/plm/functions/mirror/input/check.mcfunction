# 镜武右键覆写：在 base check 之后、base do 之前改写 right_click_run（20~29 段）
# 只对 act:1 且职业匹配的镜武生效；act:0 / 职业不符时不覆写，交回本体。
# act:0 只提示「镜武未激活」，不改 right_click_run（设计 §1.6）。
# 剑：不潜行 20（镜映），潜行 21（分影）
execute if score @s job matches 0 unless predicate pld:is_sneaking if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_sword7"}}}] run scoreboard players set @s right_click_run 20
execute if score @s job matches 0 if predicate pld:is_sneaking if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_sword7"}}}] run scoreboard players set @s right_click_run 21

# 斧：潜行 22（重影）；不潜行交回本体（无操作）
execute if score @s job matches 0 if predicate pld:is_sneaking if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_axe7"}}}] run scoreboard players set @s right_click_run 22

# 双生炉：潜行 23（镜匣）；副手元素/空都算镜匣，炉在主手或副手均可；不潜行交回本体 run 5
execute if score @s job matches 2 if predicate pld:is_sneaking if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_furnace_twin7"}}}] run scoreboard players set @s right_click_run 23
execute if score @s job matches 2 if predicate pld:is_sneaking if entity @s[nbt={Inventory:[{Slot:-106b,tag:{mirror:1,act:1,id:"panling:mirror_furnace_twin7"}}]}] run scoreboard players set @s right_click_run 23

# 拓印炉：不潜行 + 空副手 26（放印）；有元素交回本体 run 5（本体阵法）
execute if score @s job matches 2 unless predicate pld:is_sneaking if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_furnace_rub7"}}}] unless data entity @s Inventory[{Slot:-106b}] run scoreboard players set @s right_click_run 26

# act:0：不响应镜武技能，只提示「镜武未激活」；不写 right_click_run，本体照常处理（设计 §1.6）
execute if score @s job matches 0 if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_sword7"}}}] run function plm:mirror/msg/not_activated
execute if score @s job matches 0 if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_axe7"}}}] run function plm:mirror/msg/not_activated
# 炉：另一只手若持有可用的 act:1 双生炉，本次会走镜匣 23，不提示未激活（避免抢成功施放的 actionbar）
execute if score @s job matches 2 if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_furnace_twin7"}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{mirror:1,act:1,id:"panling:mirror_furnace_twin7"}}]}] run function plm:mirror/msg/not_activated
execute if score @s job matches 2 if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_furnace_rub7"}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{mirror:1,act:1,id:"panling:mirror_furnace_twin7"}}]}] run function plm:mirror/msg/not_activated
# 双生炉在副手：副手 act:0 但主手没有可用的 act:1 双生炉时才提示
execute if score @s job matches 2 if entity @s[nbt={Inventory:[{Slot:-106b,tag:{mirror:1,act:0,id:"panling:mirror_furnace_twin7"}}]}] unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_furnace_twin7"}}}] run function plm:mirror/msg/not_activated
