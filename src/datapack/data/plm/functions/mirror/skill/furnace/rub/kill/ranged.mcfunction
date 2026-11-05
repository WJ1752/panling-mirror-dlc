# advancement plm:mirror/rub/kill/ranged 的 reward
# 远程（烈焰人/恶魂/掠夺者）→ 类型 2；比亡灵低，已有 1 时不覆盖。
# 骷髅在 advancement 里归亡灵，按亡灵算（与 advancement 顺序无关）。
# 不加印：加印由 catch-all kill/other 每次击杀 +1（rubbable 另 +1）。
advancement revoke @s only plm:mirror/rub/kill/ranged
function plm:mirror/skill/furnace/rub/kill/begin
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
execute unless score @s mirror_rub_type matches 1 run scoreboard players set @s mirror_rub_type 2
function plm:mirror/skill/furnace/rub/bar
