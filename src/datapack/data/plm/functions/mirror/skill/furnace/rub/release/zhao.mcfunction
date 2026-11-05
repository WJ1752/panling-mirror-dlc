# 照妖：对显形目标额外 +15%（照妖·深 满 800 = +8pp → 23%）
# #skill mirror_skill_tmp2 = 100 + 15 + 词条（release_route 预先算好）
scoreboard players operation #temp entity_hurt_temp *= #skill mirror_skill_tmp2
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
