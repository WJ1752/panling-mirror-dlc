# @s = 本次射击的箭；#jh_pct mirror_calc = 伤害百分比（100 = 原伤害）。
# 只改真实箭的 damage NBT；pct=100 时不写回，避免截断原箭小数。
scoreboard players set #jh_dmg mirror_calc 0
execute store result score #jh_dmg mirror_calc run data get entity @s damage 100
execute unless score #jh_pct mirror_calc matches 100 run scoreboard players operation #jh_dmg mirror_calc *= #jh_pct mirror_calc
execute unless score #jh_pct mirror_calc matches 100 run scoreboard players operation #jh_dmg mirror_calc /= #const100 mirror_calc
execute unless score #jh_pct mirror_calc matches 100 if score #jh_dmg mirror_calc matches 1.. run execute store result entity @s damage double 0.01 run scoreboard players get #jh_dmg mirror_calc
tag @s add mirror_jinghua_arrow
