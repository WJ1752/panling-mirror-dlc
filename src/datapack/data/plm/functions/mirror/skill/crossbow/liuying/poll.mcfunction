# 留影 · 每 5t 检测装填完成
# 上下文：@s=玩家。只有持镜弩 act:1 时才更新 prev；换成别的物品时保留 prev，
# 避免“切走再切回仍装填”被误判成 0→1。
# review #50：非弓箭手（job!=1）或镜武未解析（mirror_parse_ok!=1）拿 act:1 镜弩不能召唤弩机。
execute unless score @s job matches 1 run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0

scoreboard players set #charged mirror_skill_tmp 0
execute store result score #charged mirror_skill_tmp run data get entity @s SelectedItem.tag.Charged
# mirror_turret_prev 未设置时也要按 0 处理（`matches 0` 对未设置分数为假）
execute if score #charged mirror_skill_tmp matches 1 unless score @s mirror_turret_prev matches 1.. run function plm:mirror/skill/crossbow/liuying/summon
scoreboard players operation @s mirror_turret_prev = #charged mirror_skill_tmp
