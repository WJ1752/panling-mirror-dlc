function pld:pre/damage/operation/armor
function pld:pre/damage/operation/enchant
function pld:pre/damage/operation/effect/check
execute unless score @s entity_hurt_temp matches 10240000.. run return 0
# 本体下面会对致死目标发 99999 魔法伤害。仅摘除这个受击盒，由事务提交完整数值。
scoreboard players operation #base_override mirror_boss_damage = @s entity_hurt_temp
tag @s remove warrior_tag
