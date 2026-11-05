# advancement plm:mirror/rub/kill/other 的 reward
# catch-all：每次击杀都会触发一次，是唯一的“击杀 +1”入口；rubbable 另由 kill/rubbable +1。
# 其他 → 类型 4（默认/定身 1s）；优先级最低，只在更高优先级都没写时写。
# begin 已把 mirror_rub_type 清 0，所以这里是“本次击杀”的类型，不是历史类型。
advancement revoke @s only plm:mirror/rub/kill/other
function plm:mirror/skill/furnace/rub/kill/begin
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
execute unless score @s mirror_rub_type matches 1..3 run scoreboard players set @s mirror_rub_type 4
function plm:mirror/skill/furnace/rub/kill
