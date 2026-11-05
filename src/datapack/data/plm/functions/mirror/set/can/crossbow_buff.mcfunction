# 残影 4 件套：齐射后 5s 内装填速度 +50%
# 镜弩基础 Quick Charge II（0.75s）→ 临时 Quick Charge III（0.5s）= 1.5× 速度 = +50%。
# @s=玩家，at @s；调用方：plm:mirror/skill/crossbow/yingsui/fire（齐射开始时）。
scoreboard players set #t mirror_set_tmp 3
function plm:mirror/set/can/tier
execute unless score @s mirror_set_4 matches 1 run return 0

# 已在 buff 中：只刷新 5s 窗口，保留最初记录的 Quick Charge 等级
execute if score @s mirror_crossbow_4_bonus matches 100.. run scoreboard players operation @s mirror_crossbow_4_until = #sys mirror_game_time
execute if score @s mirror_crossbow_4_bonus matches 100.. run scoreboard players add @s mirror_crossbow_4_until 100
execute if score @s mirror_crossbow_4_bonus matches 100.. run return 0

# 记录原始 Quick Charge 等级：100/101/102/103 = 0/1/2/3
scoreboard players set @s mirror_crossbow_4_bonus 100
scoreboard players set #qc_cur mirror_skill_tmp 0
execute store result score #qc_cur mirror_skill_tmp run data get entity @s SelectedItem.tag.Enchantments[{id:"minecraft:quick_charge"}].lvl
execute if score #qc_cur mirror_skill_tmp matches 1 run scoreboard players set @s mirror_crossbow_4_bonus 101
execute if score #qc_cur mirror_skill_tmp matches 2 run scoreboard players set @s mirror_crossbow_4_bonus 102
execute if score #qc_cur mirror_skill_tmp matches 3 run scoreboard players set @s mirror_crossbow_4_bonus 103

scoreboard players operation @s mirror_crossbow_4_until = #sys mirror_game_time
scoreboard players add @s mirror_crossbow_4_until 100
function plm:mirror/set/can/qc_apply
