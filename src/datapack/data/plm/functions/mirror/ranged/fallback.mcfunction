# 真实箭在 player_hurt_entity reward 时可能已消失（尤其弓箭）。
# 回退：用 ctx/arrow 存在射手身上的“最近一箭”快照 + 玩家 16 格内刚受伤的目标。
# 只在 ranged/hit 找不到任何自己箭实体时调用；不替代正常箭实体路径。
# @s=射手。
tag @e[tag=mirror_ranged_target] remove mirror_ranged_target
scoreboard players set #rng_ht mirror_calc 0
execute as @e[tag=monster,distance=..16,sort=nearest,limit=1] store result score #rng_ht mirror_calc run data get entity @s HurtTime
execute if score #rng_ht mirror_calc matches 1.. as @e[tag=monster,distance=..16,sort=nearest,limit=1] run tag @s add mirror_ranged_target
scoreboard players set #rng_ht mirror_calc 0
execute as @e[tag=mirror_boss,distance=..16,sort=nearest,limit=1] store result score #rng_ht mirror_calc run data get entity @s HurtTime
execute if score #rng_ht mirror_calc matches 1.. as @e[tag=mirror_boss,distance=..16,sort=nearest,limit=1] run tag @s add mirror_ranged_target
scoreboard players set #rng_ht mirror_calc 0
execute as @e[tag=mirror_summon,distance=..16,sort=nearest,limit=1] store result score #rng_ht mirror_calc run data get entity @s HurtTime
execute if score #rng_ht mirror_calc matches 1.. as @e[tag=mirror_summon,distance=..16,sort=nearest,limit=1] run tag @s add mirror_ranged_target
execute unless entity @e[tag=mirror_ranged_target,limit=1] run scoreboard players set @s mirror_last_ranged_until 0
execute unless entity @e[tag=mirror_ranged_target,limit=1] run return 0

scoreboard players operation #temp player_cause_1damage = @s mirror_last_ranged_dmg
tag @e[tag=plm_ctx_target] remove plm_ctx_target
tag @e[tag=mirror_ranged_target,limit=1] add plm_ctx_target
execute if entity @e[tag=plm_ctx_target,limit=1] run function plm:mirror/set/lie/on_hit
tag @e[tag=plm_ctx_target] remove plm_ctx_target

scoreboard players set #can_ranged mirror_skill_tmp 1
function plm:mirror/set/can/on_hit
scoreboard players set #can_ranged mirror_skill_tmp 0

execute if score @s mirror_last_jinghua_until >= #sys mirror_game_time run function plm:mirror/set/jing_hua/on_normal_hit

scoreboard players set @s mirror_last_ranged_until 0
scoreboard players set @s mirror_last_jinghua_until 0
tag @e[tag=mirror_ranged_target] remove mirror_ranged_target
