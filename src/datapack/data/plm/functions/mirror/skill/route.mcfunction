# 镜武主动技能总入口（挂在 #pld:right_click/do）
# 只处理 DLC 在 check 阶段覆写的 right_click_run 20~29；其它值直接交回本体。
execute unless score @s right_click_run matches 20..29 run return 0

# 20 镜映：保留原冷却/明镜判断（明镜可跳过 mirror_cd_a）
# 施法锁：0.5s 内重复触发直接丢弃，不扣冷却（设计 §1.6）
execute if score @s right_click_run matches 20 if score @s mirror_cast_lock matches 1.. run return 0
execute if score @s right_click_run matches 20 if score @s mirror_cd_a matches 1.. unless score @s mirror_mingjing matches 1.. run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_a
execute if score @s right_click_run matches 20 if score @s mirror_cd_a matches 1.. unless score @s mirror_mingjing matches 1.. run function plm:mirror/msg/cooling
execute if score @s right_click_run matches 20 if score @s mirror_cd_a matches 1.. unless score @s mirror_mingjing matches 1.. run return 0
execute if score @s right_click_run matches 20 if entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_sword7"}}}] run function plm:mirror/skill/parry/start

# 21 分影：内部自带 mirror_cd_b / 明镜判断
execute if score @s right_click_run matches 21 run function plm:mirror/skill/shadow/route

# 22 重影：内部自带共享 mirror_cd_a / 手持判定
execute if score @s right_click_run matches 22 run function plm:mirror/skill/axe/chongying/route

# 23 双生镜匣
execute if score @s right_click_run matches 23 run function plm:mirror/skill/furnace/twin/box_route

# 26 拓印放印
execute if score @s right_click_run matches 26 run function plm:mirror/skill/furnace/rub/release_route
