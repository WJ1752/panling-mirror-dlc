# 击杀加印（catch-all：由 kill/other 的 reward 每次击杀调用一次）
# @s = 击杀玩家
# 同 tick 多杀：每次都 +1；不再用 mirror_rub_award / gametime 做同一 tick 去重。
# rubbable 的额外 +1 由 kill/rubbable 自己加，不经过本函数。
# 只有手持拓印镜炉（主手或副手，act:1）才积累
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
scoreboard players add @s mirror_rub_stack 1
function plm:mirror/skill/furnace/rub/bonus
