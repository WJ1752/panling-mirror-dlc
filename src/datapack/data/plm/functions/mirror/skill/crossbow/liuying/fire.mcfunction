# 留影 · 弩机射击（@s=弩机；at @s）
# 先重设下一次间隔（即使没有目标也要走时钟），再找 8 格内最近敌人。
scoreboard players operation @s mirror_turret_interval = @s mirror_turret_atk
scoreboard players operation #m mirror_skill_tmp = @s mirror_turret_shots
scoreboard players operation #m mirror_skill_tmp %= #const2 mirror_calc
execute if score @s mirror_turret_count matches 1 if score #m mirror_skill_tmp matches 1 run scoreboard players add @s mirror_turret_interval 1

# 单台最多 6 发
execute if score @s mirror_turret_shots matches 6.. run return 0

tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
execute at @s run tag @e[tag=monster,distance=..8,sort=nearest,limit=1] add mirror_dmg_target
execute at @s unless entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_boss,distance=..8,sort=nearest,limit=1] add mirror_dmg_target
execute at @s unless entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_summon,distance=..8,sort=nearest,limit=1] add mirror_dmg_target
execute unless entity @e[tag=mirror_dmg_target,limit=1] run return 0

execute at @s run tp @s ~ ~ ~ facing entity @e[tag=mirror_dmg_target,limit=1] feet
execute at @s run summon minecraft:arrow ^ ^1.2 ^0.8 {Tags:["mirror_turret_arrow","mirror_shot_new"],pickup:2b,crit:0b,Motion:[0.0d,0.0d,0.0d]}

# 弩机箭补 Owner（review #48）：mirror_turret_owner 存的是 player_uid，反查在线玩家 UUID。
# 原版 Projectile.canHitEntity 在 leftOwner=false（箭还没离开主人）期间禁止命中 Owner：
# 弩机通常就站在主人召唤点，出膛第一段不会打到主人。主人离线时保持无 Owner，不误配别人。
# #cbown 先归 0：operation 在源分数缺失时不会写入，避免沿用上一次的 uid。
scoreboard players set #cbown mirror_skill_tmp 0
scoreboard players operation #cbown mirror_skill_tmp = @s mirror_turret_owner
execute as @a if score @s player_uid = #cbown mirror_skill_tmp run data modify entity @e[tag=mirror_shot_new,limit=1] Owner set from entity @s UUID
# 直接结算需要反查射手；把 player_uuid0..3 抄到箭上（Owner 只保存世界 UUID）。
execute as @a if score @s player_uid = #cbown mirror_skill_tmp run scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid0 = @s player_uuid0
execute as @a if score @s player_uid = #cbown mirror_skill_tmp run scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid1 = @s player_uuid1
execute as @a if score @s player_uid = #cbown mirror_skill_tmp run scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid2 = @s player_uuid2
execute as @a if score @s player_uid = #cbown mirror_skill_tmp run scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid3 = @s player_uuid3

# 发射点（弩机脚下 +1.2）
execute store result score #cbpx mirror_wtmp run data get entity @s Pos[0] 100
execute store result score #cbpy mirror_wtmp2 run data get entity @s Pos[1] 100
scoreboard players add #cbpy mirror_wtmp2 120
execute store result score #cbpz mirror_wtmp3 run data get entity @s Pos[2] 100
scoreboard players operation #cbdmg mirror_wtmp12 = @s mirror_turret_ratio
function plm:mirror/skill/crossbow/shot/aim
tag @e[tag=mirror_shot_new] remove mirror_shot_new
# aim 只借用 mirror_dmg_target 找目标；结算不走 armor，用完立刻清，避免残留到下一次技能
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target

scoreboard players add @s mirror_turret_shots 1
execute at @s run playsound minecraft:item.crossbow.shoot master @a ~ ~ ~ 0.5 1.4
# 1t 直接结算循环：只在有技能箭时运行，无箭自停
schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
