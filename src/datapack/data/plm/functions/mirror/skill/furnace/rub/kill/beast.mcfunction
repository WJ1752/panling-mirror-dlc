# advancement plm:mirror/rub/kill/beast 的 reward
# 兽（节肢动物/动物）→ 类型 3；低于亡灵/远程，已有 1 或 2 时不覆盖。
# 不加印：加印由 catch-all kill/other 每次击杀 +1（rubbable 另 +1）。
advancement revoke @s only plm:mirror/rub/kill/beast
function plm:mirror/skill/furnace/rub/kill/begin
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
execute unless score @s mirror_rub_type matches 1..2 run scoreboard players set @s mirror_rub_type 3
function plm:mirror/skill/furnace/rub/bar
