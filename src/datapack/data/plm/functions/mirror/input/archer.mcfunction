# 镜弓/镜弩潜行射箭：@s=射手，箭已射出、本体 projectile_owner_uuid0..3 已写
# 只分发技能入口；这一箭仍正常飞出（技能只给箭打 tag / 记录路径 / 开冷却）。
execute unless score @s job matches 1 run return 0
execute unless predicate pld:is_sneaking run return 0
# act:0：不响应镜武技能，只提示「镜武未激活」；箭照常飞出（设计 §1.6）
execute if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_bow7"}}}] run function plm:mirror/msg/not_activated
execute if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_crossbow7"}}}] run function plm:mirror/msg/not_activated
execute if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_bow7"}}}] run return 0
execute if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:0,id:"panling:mirror_crossbow7"}}}] run return 0
# 只有主手 act:1 的镜弓/镜弩才进入技能分流；其余弓弩交回本体普通射击
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_bow7"}}}] unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
# 冷却检查放在各自 route：镜花满层免费（mirror_bloom_free=1）可绕过共享 mirror_cd_a；
# 影随的 cast_lock / 冷却也在 crossbow/route 里统一处理。
execute at @s if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_bow7"}}}] run function plm:mirror/skill/bow/route
execute at @s if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_crossbow7"}}}] run function plm:mirror/skill/crossbow/route
