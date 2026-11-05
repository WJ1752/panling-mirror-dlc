# 折光（zhe_guang）— 受到投射物伤害时概率反射，造成 20% 伤害。
# 触发：advancement plm:weapon/projectile_hurt（entity_hurt_player + damage.type=is_projectile）。
# 口径限制（明确写死，不伪造精确值）：
#   - reward 里没有 source/damage 直接分数，攻击者与投射物类型都取不到；
#   - 伤害量只能用 5t 生命快照差（mirror_hp_last − 当前 Health，快照超过 10t 视为过期不估值）。
#     本体 `damage` 追踪分数在已安装的包里没有写入者（pld:pre/damage/update 无调用），不再读它；
#   - 反射目标用 12 格内最近的白名单敌人近似「攻击者」。
advancement revoke @s only plm:weapon/projectile_hurt
execute unless score @s wp_affix_fx_zhe_guang matches 1.. run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0

# 伤害量（快照差近似；过期/无快照则不触发）
scoreboard players set #wp mirror_wtmp2 0
function plm:weapon/fx/zhe_guang/estimate
execute unless score #wp mirror_wtmp2 matches 1.. run return 0

# 触发率（wp_affix = 实际百分点×10 → /10 = 百分比整数）
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_fx_zhe_guang
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
function plm:weapon/util/rand100
execute if score #t wp_rand > #wp mirror_wtmp run return 0

# 20%
scoreboard players operation #temp entity_hurt_temp = #wp mirror_wtmp2
scoreboard players operation #temp entity_hurt_temp *= #const20 mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
# 共鸣（折光 + 背照）：反射伤害视为从背后命中 → 追加背照百分比
scoreboard players set #wp mirror_wtmp3 0
execute if score @s wp_affix_dmg_bei_zhao matches 1.. run scoreboard players operation #wp mirror_wtmp3 = @s wp_affix_dmg_bei_zhao
execute if score #wp mirror_wtmp3 matches 1.. run scoreboard players add #wp mirror_wtmp3 1000
execute if score #wp mirror_wtmp3 matches 1.. run scoreboard players operation #temp entity_hurt_temp *= #wp mirror_wtmp3
execute if score #wp mirror_wtmp3 matches 1.. run scoreboard players operation #temp entity_hurt_temp /= #const1000 mirror_calc
execute unless score #temp entity_hurt_temp matches 1.. run return 0

# 反射目标：12 格内最近的白名单敌人
tag @e[tag=wp_zheguang_cand] remove wp_zheguang_cand
execute at @s run tag @e[tag=monster,distance=..12] add wp_zheguang_cand
execute at @s run tag @e[tag=mirror_boss,distance=..12] add wp_zheguang_cand
execute at @s run tag @e[tag=mirror_summon,distance=..12] add wp_zheguang_cand
execute at @s run tag @e[tag=wp_zheguang_cand,sort=nearest,limit=1] add wp_zheguang_target
execute unless entity @e[tag=wp_zheguang_target,limit=1] run return 0
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=wp_zheguang_target,limit=1] add mirror_dmg_target
execute as @e[tag=wp_zheguang_target,limit=1] at @s run particle minecraft:dust 0.7 0.9 1 1 ~ ~1 ~ 0.3 0.4 0.3 0.02 10
function plm:mirror/damage/armor
tag @e[tag=wp_zheguang_cand] remove wp_zheguang_cand
tag @e[tag=wp_zheguang_target] remove wp_zheguang_target
