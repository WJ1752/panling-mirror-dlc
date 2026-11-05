# 裂影 2 件套：造成伤害 10% 概率追加一次 15% 影伤；影伤可暴击。
# @s=玩家；plm_ctx_target=本次直接命中目标；#temp player_cause_1damage=本次伤害（×10，10=1HP）。
# 影伤不加裂痕层（硬规则）。
# 暴击：只有明确带箭头暴击标记的来源（镜花命中里 mirror_form=2 + mirror_axe_2_crit）才 ×1.5；
# 1.20.1 的 when_hurt_entity 拿不到近战 vanilla 暴击信息，近战影伤暴击见 blocker。
scoreboard players set @s mirror_set_count 0
scoreboard players operation @s mirror_set_count = @s mirror_set_b
execute if score @s mirror_set matches 1 run scoreboard players operation @s mirror_set_count -= @s mirror_set_weapon
execute if score @s mirror_set_count matches ..1 run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score #temp player_cause_1damage matches 1.. run return 0

# 10% 概率
function plm:weapon/util/rand100
execute unless score #t wp_rand matches ..10 run return 0

# 影伤 = 本次伤害 × 15%（#temp 从 ×10 转 ×100：P×15/10）
scoreboard players set #lie15 mirror_calc 15
scoreboard players set #lie10 mirror_calc 10
scoreboard players set #lie100 mirror_calc 100
scoreboard players set #lie150 mirror_calc 150
scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage
scoreboard players operation #temp entity_hurt_temp *= #lie15 mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #lie10 mirror_calc

# 可暴击（仅限带明确暴击标记的来源）：此时 #temp 已是 2 位小数，×150/100
scoreboard players set #lie_crit mirror_calc 0
execute if score @s mirror_form matches 2 run scoreboard players operation #lie_crit mirror_calc = @s mirror_axe_2_crit
execute if score #lie_crit mirror_calc matches 1 run scoreboard players operation #temp entity_hurt_temp *= #lie150 mirror_calc
execute if score #lie_crit mirror_calc matches 1 run scoreboard players operation #temp entity_hurt_temp /= #lie100 mirror_calc

tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=plm_ctx_target,limit=1] add mirror_dmg_target
function plm:mirror/set/zhao/vuln
execute as @e[tag=mirror_dmg_target,limit=1] at @s run particle minecraft:dust 0.9 0.1 0.1 1 ~ ~1 ~ 0.3 0.3 0.3 0.03 8
function plm:mirror/damage/armor
