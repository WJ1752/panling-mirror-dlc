# 4 件套装填 buff 结束：把 Quick Charge 还原到 buff 前等级
# @s=玩家；不手持镜弩时保留状态，等下次手持再还原（避免永久 QC3）。
# 优先读物品上的 mirror_qc3_base（死亡/换手后分数可能已清），没有才退回 mirror_crossbow_4_bonus。
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
scoreboard players set #qc_lvl mirror_skill_tmp2 -1
execute store result score #qc_lvl mirror_skill_tmp2 run data get entity @s SelectedItem.tag.mirror_qc3_base
execute unless score @s mirror_crossbow_4_bonus matches 100.. run return 0
execute if score #qc_lvl mirror_skill_tmp2 matches ..-1 run scoreboard players operation #qc_lvl mirror_skill_tmp2 = @s mirror_crossbow_4_bonus
execute if score #qc_lvl mirror_skill_tmp2 matches ..-1 run scoreboard players remove #qc_lvl mirror_skill_tmp2 100
# 当前等级已等于原始等级：直接清状态
scoreboard players set #qc_cur mirror_skill_tmp 0
execute store result score #qc_cur mirror_skill_tmp run data get entity @s SelectedItem.tag.Enchantments[{id:"minecraft:quick_charge"}].lvl
execute if score #qc_cur mirror_skill_tmp = #qc_lvl mirror_skill_tmp2 run scoreboard players set @s mirror_crossbow_4_bonus 0
execute if score #qc_cur mirror_skill_tmp = #qc_lvl mirror_skill_tmp2 run scoreboard players set @s mirror_crossbow_4_until 0
execute if score #qc_cur mirror_skill_tmp = #qc_lvl mirror_skill_tmp2 run scoreboard players set #qc_mark mirror_skill_tmp3 0
execute if score #qc_cur mirror_skill_tmp = #qc_lvl mirror_skill_tmp2 run return 0
scoreboard players set #qc_mark mirror_skill_tmp3 0
execute if score #qc_lvl mirror_skill_tmp2 matches 1.. run function plm:mirror/set/can/qc_write
execute if score #qc_lvl mirror_skill_tmp2 matches ..0 run function plm:mirror/set/can/qc_remove
scoreboard players set @s mirror_crossbow_4_bonus 0
scoreboard players set @s mirror_crossbow_4_until 0
