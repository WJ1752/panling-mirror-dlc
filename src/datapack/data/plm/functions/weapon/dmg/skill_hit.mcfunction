# 映刃（ying_ren）统一结算点 + 映声（ying_sheng）触发点
# 触发：advancement plm:weapon/skill_hit（player_hurt_entity；伤害属于 #minecraft:bypasses_armor，
#       排除投射物与普攻）。技能函数在调用 plm:mirror/damage/armor 期间保留 tag=mirror_skill，
#       且 #temp entity_hurt_temp 仍是本次技能伤害（×100，2 位小数）。
# 为什么不在 ctx/melee：技能伤害直写 #temp entity_hurt_temp，不经过 multiply_base。
advancement revoke @s only plm:weapon/skill_hit
execute unless entity @s[tag=mirror_skill] run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0
# 防递归：本函数自己造成的追加伤害同样带 mirror_skill（调用方 tag 窗口内）
execute if entity @s[tag=mirror_skill_boost] run return 0
# 本次受害者：技能管线在调 mirror/damage/armor 前已把受害者打成 mirror_dmg_target
# （parry/hurt、axe/lie/victim、bow/slot_apply 都遵守）。不用「最近 HurtTime>0」猜测：
# 范围引爆时那样会对同一个最近目标重复叠 12%，远程绽放时会打到射手附近的另一只怪。
execute unless entity @e[tag=mirror_dmg_target,limit=1] run return 0

# 映声：武器技命中概率减少 1s 冷却（先算，避免追加伤害再次触发）
function plm:weapon/fx/ying_sheng

# 映刃：+12%（wp_affix = 实际百分点×10；×100 伤害 × pp / 1000 = 追加伤害在 ×100 下的值）
execute if score @s wp_affix_dmg_ying_ren matches 1.. if score #temp entity_hurt_temp matches 1.. run tag @s add mirror_skill_boost
execute if score @s wp_affix_dmg_ying_ren matches 1.. if score #temp entity_hurt_temp matches 1.. run scoreboard players operation #temp entity_hurt_temp *= @s wp_affix_dmg_ying_ren
execute if score @s wp_affix_dmg_ying_ren matches 1.. if score #temp entity_hurt_temp matches 1.. run scoreboard players operation #temp entity_hurt_temp /= #const1000 mirror_calc
execute if score @s wp_affix_dmg_ying_ren matches 1.. if score #temp entity_hurt_temp matches 1.. run function plm:mirror/damage/armor
tag @s remove mirror_skill_boost
