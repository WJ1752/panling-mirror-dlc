# @s = 倒影；找 5 格内最近敌人，转向并由 owner 结算一次镜伤
# 索敌：monster / mirror_boss / mirror_summon（CONTRACT §4 白名单）
# 伤害归属：mirror_shadow_owner 对应玩家，不再用最近的 @p。
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
# 5 格内白名单三类先打候选 tag，再按距离取最近的一个（#6）：
# 旧写法是 monster → boss → summon 的优先级，boss 比 monster 近也会先打 monster。
tag @e[tag=mirror_shadow_cand] remove mirror_shadow_cand
execute at @s run tag @e[tag=monster,distance=..5] add mirror_shadow_cand
execute at @s run tag @e[tag=mirror_boss,distance=..5] add mirror_shadow_cand
execute at @s run tag @e[tag=mirror_summon,distance=..5] add mirror_shadow_cand
execute at @s run tag @e[tag=mirror_shadow_cand,sort=nearest,limit=1] add mirror_dmg_target
tag @e[tag=mirror_shadow_cand] remove mirror_shadow_cand
execute if entity @e[tag=mirror_dmg_target] at @s run tp @s ~ ~ ~ facing entity @e[tag=mirror_dmg_target,limit=1] feet

scoreboard players operation #skill mirror_skill_atk = @s mirror_shadow_atk
scoreboard players operation #skill mirror_skill_ratio = @s mirror_shadow_ratio
function plm:mirror/skill/shadow/owner_mark
execute if entity @e[tag=mirror_dmg_target] if entity @a[tag=mirror_shadow_owner_ref,distance=..16] as @a[tag=mirror_shadow_owner_ref,limit=1] run function plm:mirror/skill/shadow/damage
# 主人不在 16 格内 / 不在同一维度：本次不结算，清掉目标 tag
execute unless entity @a[tag=mirror_shadow_owner_ref,limit=1] run tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @a remove mirror_shadow_owner_ref
# 下次间隔：基础档 4 时按攻击计数奇偶在 4/5 个 5t 间交替（平均 4.5 = 1.125s）；
# 5/6 档保持固定，最低 4 的保护已在 start 钳位。
scoreboard players add @s mirror_shadow_hits 1
scoreboard players operation @s mirror_shadow_atk_timer = @s mirror_shadow_interval
scoreboard players operation #skill mirror_skill_tmp3 = @s mirror_shadow_hits
scoreboard players operation #skill mirror_skill_tmp3 %= #const2 mirror_calc
execute if score @s mirror_shadow_interval matches 4 if score #skill mirror_skill_tmp3 matches 1 run scoreboard players set @s mirror_shadow_atk_timer 5
execute if score @s mirror_shadow_interval matches 4 if score #skill mirror_skill_tmp3 matches 0 run scoreboard players set @s mirror_shadow_atk_timer 4
