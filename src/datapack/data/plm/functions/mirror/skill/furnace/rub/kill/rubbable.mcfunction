# advancement plm:mirror/rub/kill/rubbable 的 reward
# rubbable 怪额外 +1 印（设计 §2.6.1）：基础 +1 由 catch-all kill/other 负责，合计 +2。
# 按次结算：同 tick 多只 rubbable 各 +1，不再用 mirror_rub_award / gametime 去重。
advancement revoke @s only plm:mirror/rub/kill/rubbable
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
function plm:mirror/skill/furnace/rub/kill/begin
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
scoreboard players add @s mirror_rub_stack 1
function plm:mirror/skill/furnace/rub/clamp
