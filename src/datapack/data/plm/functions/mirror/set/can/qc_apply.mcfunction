# 4 件套装填 buff：把主手镜弩临时写到 Quick Charge III
# @s=玩家；只在确实手持 act:1 镜弩且当前等级 <3 时改物品。
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
scoreboard players set #qc_cur mirror_skill_tmp 0
execute store result score #qc_cur mirror_skill_tmp run data get entity @s SelectedItem.tag.Enchantments[{id:"minecraft:quick_charge"}].lvl
execute if score #qc_cur mirror_skill_tmp matches 3.. run return 0
scoreboard players set #qc_lvl mirror_skill_tmp2 3
scoreboard players set #qc_mark mirror_skill_tmp3 1
function plm:mirror/set/can/qc_write
