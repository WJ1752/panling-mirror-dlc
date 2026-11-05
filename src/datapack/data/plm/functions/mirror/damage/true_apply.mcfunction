# 真伤包装的目标侧：@s = 目标
scoreboard players operation @s entity_hurt_temp = #temp entity_hurt_temp
function pld:pre/damage/public_damage_entity_pass_armor
