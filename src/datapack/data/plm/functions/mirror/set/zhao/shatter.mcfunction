# 碎镜：@s=玩家；仅在照心 4 件套、镜心满 5 层时由 heart_add 调用。
# 5 格内所有白名单敌人吃 层数×80%（层数=5）的镜伤；命中者 3s 内受到镜武伤害 +15%。
# 真影律：伤害改真伤，并在碎镜后给 5s 明镜（mirror_mingjing=20 个 5t 单位）。
function plm:mirror/set/zhao/true_law
scoreboard players set #zhao_layers mirror_calc 0
scoreboard players operation #zhao_layers mirror_calc = @s mirror_heart
execute unless score #zhao_layers mirror_calc matches 5 run return 0

# 基数：近战攻击力 attack_damage1（×10）；弓/非法师玩家为 0 时退回 archer_damage_should。
# 2 位小数伤害 = base×10 × 层数 × 80 / 100（100=1HP）。
scoreboard players set #zhao_base mirror_calc 0
scoreboard players operation #zhao_base mirror_calc = @s attack_damage1
execute if score #zhao_base mirror_calc matches ..0 run scoreboard players operation #zhao_base mirror_calc = @s archer_damage_should
scoreboard players set #zhao80 mirror_calc 80
scoreboard players set #zhao100 mirror_calc 100
scoreboard players set #zhao_dmg mirror_calc 0
scoreboard players set #zhao_true mirror_calc 0
scoreboard players operation #zhao_dmg mirror_calc = #zhao_base mirror_calc
scoreboard players operation #zhao_dmg mirror_calc *= #const10 mirror_calc
scoreboard players operation #zhao_dmg mirror_calc *= #zhao_layers mirror_calc
scoreboard players operation #zhao_dmg mirror_calc *= #zhao80 mirror_calc
scoreboard players operation #zhao_dmg mirror_calc /= #zhao100 mirror_calc
# 真伤是 4 位小数（10000=1HP）
scoreboard players operation #zhao_true mirror_calc = #zhao_dmg mirror_calc
scoreboard players operation #zhao_true mirror_calc *= #zhao100 mirror_calc

# 5 格内白名单：monster / mirror_boss / mirror_summon
tag @e[tag=mirror_shatter_victim] remove mirror_shatter_victim
execute at @s run tag @e[tag=monster,distance=..5] add mirror_shatter_victim
execute at @s run tag @e[tag=mirror_boss,distance=..5] add mirror_shatter_victim
execute at @s run tag @e[tag=mirror_summon,distance=..5] add mirror_shatter_victim
tag @s add mirror_shatter_owner
execute if score @s mirror_true_law matches 1 run tag @s add mirror_shatter_true
execute as @e[tag=mirror_shatter_victim] run function plm:mirror/set/zhao/shatter_victim
tag @s remove mirror_shatter_owner
tag @s remove mirror_shatter_true
tag @e[tag=mirror_shatter_victim] remove mirror_shatter_victim

# 消耗镜心
scoreboard players set @s mirror_heart 0
scoreboard players set @s mirror_heart_until 0
# 真影律：碎镜后明镜必触发（5s）
execute if score @s mirror_true_law matches 1 run scoreboard players set @s mirror_mingjing 20
execute if score @s mirror_true_law matches 1 run particle minecraft:end_rod ~ ~1 ~ 0.8 1 0.8 0.05 32
execute at @s run particle minecraft:item minecraft:white_stained_glass ~ ~1 ~ 1 0.8 1 0.1 28
execute at @s run particle minecraft:crit ~ ~1 ~ 1 0.8 1 0.1 20
execute at @s run playsound minecraft:block.glass.break master @a ~ ~ ~ 1 0.7
