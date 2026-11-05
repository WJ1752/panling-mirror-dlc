# 续影（xu_ying）— target（弓/弩命中侧）
# 同一目标连续命中每层 +4%，上限 3 层；层数由 archer_hit 在命中时维护（mirror_xu_streak）
execute unless score @s wp_affix_dmg_xu_ying matches 1.. run return 0
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s mirror_xu_streak
scoreboard players operation #wp mirror_wtmp *= @s wp_affix_dmg_xu_ying
scoreboard players operation @s mirror_ctx_extra += #wp mirror_wtmp
