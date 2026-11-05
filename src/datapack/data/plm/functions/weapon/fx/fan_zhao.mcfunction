# 反照（fan_zhao）— 受击概率使攻击者减速 15%，持续 1s。
# 触发：plm:weapon/event/damaged（#pld:equipment_lock/when_damaged）。
# 限制：when_damaged 没有攻击者上下文，用 6 格内最近的白名单敌人近似「攻击者」；
#       slowness I = -15% 移动速度，正好等于设计值。
execute unless score @s wp_affix_fx_fan_zhao matches 1.. run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_fx_fan_zhao
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
function plm:weapon/util/rand100
execute if score #t wp_rand > #wp mirror_wtmp run return 0
tag @e[tag=wp_fanzhao_cand] remove wp_fanzhao_cand
execute at @s run tag @e[tag=monster,distance=..6] add wp_fanzhao_cand
execute at @s run tag @e[tag=mirror_boss,distance=..6] add wp_fanzhao_cand
execute at @s run tag @e[tag=mirror_summon,distance=..6] add wp_fanzhao_cand
execute at @s run tag @e[tag=wp_fanzhao_cand,sort=nearest,limit=1] add wp_fanzhao_target
execute unless entity @e[tag=wp_fanzhao_target,limit=1] run return 0
effect give @e[tag=wp_fanzhao_target,limit=1] minecraft:slowness 1 0 true
execute as @e[tag=wp_fanzhao_target,limit=1] at @s run particle minecraft:dust 1 0.75 0.4 1 ~ ~1 ~ 0.3 0.4 0.3 0.02 8
tag @e[tag=wp_fanzhao_cand] remove wp_fanzhao_cand
tag @e[tag=wp_fanzhao_target] remove wp_fanzhao_target
