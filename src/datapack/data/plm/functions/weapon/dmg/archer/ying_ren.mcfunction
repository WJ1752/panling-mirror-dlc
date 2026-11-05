# 映刃（ying_ren）— 武器技伤害（弓/弩侧）
# 技能伤害直写 #temp entity_hurt_temp、不经过 multiply_base，命中箭也不走 player_hurt_entity 的
# 普攻管线；统一结算点是 advancement plm:weapon/skill_hit → plm:weapon/dmg/skill_hit。
# 这里只在「本次箭命中恰好也是技能伤害」时补一条，正常普攻箭为 0 加成。
execute unless score @s wp_affix_dmg_ying_ren matches 1.. run return 0
execute unless entity @s[tag=mirror_skill] run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_ying_ren
