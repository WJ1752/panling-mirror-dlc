# advancement plm:mirror/rub/kill/undead 的 reward
# 亡灵 → 类型 1；优先级最高，总是写入。begin 负责本 tick 的类型清零。
# 不加印：加印由 catch-all kill/other 每次击杀 +1（rubbable 另 +1）。
# （1.20.1 没有 #minecraft:undead 实体标签，advancement 里用逐类型 criteria 的 OR 组）
advancement revoke @s only plm:mirror/rub/kill/undead
function plm:mirror/skill/furnace/rub/kill/begin
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
scoreboard players set @s mirror_rub_type 1
function plm:mirror/skill/furnace/rub/bar
