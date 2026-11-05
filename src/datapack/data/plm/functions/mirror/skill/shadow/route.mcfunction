# 潜行右键：分影。冷却独立 mirror_cd_b；明镜可跳过。
# 施法锁：0.5s 内重复触发直接丢弃，不扣冷却（设计 §1.6）
execute if score @s mirror_cast_lock matches 1.. run return 0
execute if score @s mirror_cd_b matches 1.. unless score @s mirror_mingjing matches 1.. run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_b
execute if score @s mirror_cd_b matches 1.. unless score @s mirror_mingjing matches 1.. run function plm:mirror/msg/cooling
execute if score @s mirror_cd_b matches 1.. unless score @s mirror_mingjing matches 1.. run return 0
execute if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_sword7"}}}] run function plm:mirror/skill/shadow/start
