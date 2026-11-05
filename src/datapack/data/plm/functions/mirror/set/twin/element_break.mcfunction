# 双生 4 件套「相克」：目标元素抗性下降一级（10s，DLC 私有 debuff）
# @s = 目标敌人；不改原版 Resistance/ActiveEffects，只在 DLC 阵法伤害结算时读 mirror_element_break。
scoreboard players operation @s mirror_element_break = #sys mirror_game_time
scoreboard players add @s mirror_element_break 200
tag @s add mirror_element_break_active
