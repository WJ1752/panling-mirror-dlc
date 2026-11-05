# 照心受击的减伤结算：@s=玩家，调用前已确认 mirror_heart >= 1。
# 把“每层 4% 减伤”折算成治疗债务，再由 debt 用 instant_health 返还。
# 依赖 zhao/snapshot 记录的受击前 Health（mirror_shatter_target）。
# 1.20.1 没有受伤倍率/分数治疗，这里不是逐击精确 4%：致命一击救不回，
# Absorption 期间 Health 不变也测不到（交付文档必须按这个口径写）。

execute store result score #zhao_now mirror_calc run data get entity @s Health 100
scoreboard players set #zhao_dmg mirror_calc 0
scoreboard players operation #zhao_dmg mirror_calc = @s mirror_shatter_target
scoreboard players operation #zhao_dmg mirror_calc -= #zhao_now mirror_calc
# 没有受击前快照 / 治疗导致负伤害：只更新快照
execute if score #zhao_dmg mirror_calc matches ..0 run scoreboard players operation @s mirror_shatter_target = #zhao_now mirror_calc
execute if score #zhao_dmg mirror_calc matches ..0 run return 0

# 债务 = 伤害 × 层数 × 4 / 100（2 位小数）
scoreboard players operation #zhao_heal mirror_calc = #zhao_dmg mirror_calc
scoreboard players operation #zhao_heal mirror_calc *= @s mirror_heart
scoreboard players operation #zhao_heal mirror_calc *= #const4 mirror_calc
scoreboard players operation #zhao_heal mirror_calc /= #const100 mirror_calc
scoreboard players operation @s mirror_shatter += #zhao_heal mirror_calc
execute if score @s mirror_shatter matches 3201.. run scoreboard players set @s mirror_shatter 3200
function plm:mirror/set/zhao/debt
# debt 已返还部分 Health；把快照更新到返还后的值，避免下一次受击把治疗算成伤害
execute store result score @s mirror_shatter_target run data get entity @s Health 100
