# 潜行右键：重影（裂影斧）
# 主主动统一使用共享 mirror_cd_a（CONTRACT §3）；旧的私有 mirror_cd_axe_a 已移除。
# 施法锁：0.5s 内重复触发直接丢弃，不扣冷却（设计 §1.6）
execute if score @s mirror_cast_lock matches 1.. run return 0
execute if score @s mirror_cd_a matches 1.. run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_a
execute if score @s mirror_cd_a matches 1.. run function plm:mirror/msg/cooling
execute if score @s mirror_cd_a matches 1.. run return 0
execute if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_axe7"}}}] run function plm:mirror/skill/axe/chongying/start
