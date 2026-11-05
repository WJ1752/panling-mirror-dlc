# 单支技能箭的直接结算（@s=箭，at @s）
# 真实箭 damage=0；只有 monster / mirror_boss / mirror_summon 会被这里结算。
# 已插地/插墙的箭不再结算，避免隔墙命中；清理由 arrow/tick 统一做。
execute if data entity @s {inGround:1b} run return 0
tag @e[tag=mirror_arrow_hit] remove mirror_arrow_hit
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
execute at @s run tag @e[tag=monster,distance=..1.8,sort=nearest,limit=1] add mirror_arrow_hit
execute at @s unless entity @e[tag=mirror_arrow_hit,limit=1] run tag @e[tag=mirror_boss,distance=..1.8,sort=nearest,limit=1] add mirror_arrow_hit
execute at @s unless entity @e[tag=mirror_arrow_hit,limit=1] run tag @e[tag=mirror_summon,distance=..1.8,sort=nearest,limit=1] add mirror_arrow_hit
execute unless entity @e[tag=mirror_arrow_hit,limit=1] run return 0

# 命中时箭速（×100）。不衰减箭固定按 300（3.0 格/t）结算。
execute unless entity @s[tag=mirror_no_falloff] run function plm:mirror/skill/crossbow/arrow/speed
execute if entity @s[tag=mirror_no_falloff] run scoreboard players set #speed100 mirror_wtmp11 300

# 箭基伤（0.1 HP 定点）
scoreboard players set #cbdmg mirror_wtmp12 0
execute store result score #cbdmg mirror_wtmp12 run data get entity @s mirror_dmg
execute if score #cbdmg mirror_wtmp12 matches ..0 run tag @e[tag=mirror_arrow_hit] remove mirror_arrow_hit
execute if score #cbdmg mirror_wtmp12 matches ..0 run kill @s
execute if score #cbdmg mirror_wtmp12 matches ..0 run return 0

# 2 位小数伤害 = 基伤 × 速度×100 / 10
scoreboard players operation #temp entity_hurt_temp = #cbdmg mirror_wtmp12
scoreboard players operation #temp entity_hurt_temp *= #speed100 mirror_wtmp11
scoreboard players operation #temp entity_hurt_temp /= #const10 mirror_calc

# 归属：projectile_owner_uuid0..3 -> 在线玩家
scoreboard players set #cbown mirror_skill_tmp 0
scoreboard players set #cbown mirror_skill_tmp2 0
scoreboard players set #cbown mirror_skill_tmp3 0
scoreboard players set #cbown mirror_wtmp 0
scoreboard players operation #cbown mirror_skill_tmp = @s projectile_owner_uuid0
scoreboard players operation #cbown mirror_skill_tmp2 = @s projectile_owner_uuid1
scoreboard players operation #cbown mirror_skill_tmp3 = @s projectile_owner_uuid2
scoreboard players operation #cbown mirror_wtmp = @s projectile_owner_uuid3
tag @a remove mirror_arrow_owner
execute as @a if score @s player_uuid0 = #cbown mirror_skill_tmp if score @s player_uuid1 = #cbown mirror_skill_tmp2 if score @s player_uuid2 = #cbown mirror_skill_tmp3 if score @s player_uuid3 = #cbown mirror_wtmp run tag @s add mirror_arrow_owner
execute unless entity @a[tag=mirror_arrow_owner,limit=1] run tag @e[tag=mirror_arrow_hit] remove mirror_arrow_hit
execute unless entity @a[tag=mirror_arrow_owner,limit=1] run kill @s
execute unless entity @a[tag=mirror_arrow_owner,limit=1] run return 0

# 连影记账：齐射箭按玩家箭；弩机箭只在 2 件套且不触发第 4 发
tag @e[tag=mirror_arrow_hit,limit=1] add mirror_lian_hit_target
execute if entity @s[tag=mirror_yingsui_arrow] as @a[tag=mirror_arrow_owner,limit=1] run function plm:mirror/skill/crossbow/lian/record_player
execute if entity @s[tag=mirror_turret_arrow] as @a[tag=mirror_arrow_owner,limit=1] run function plm:mirror/skill/crossbow/lian/record_turret
tag @e[tag=mirror_lian_hit_target] remove mirror_lian_hit_target

# 实际伤害（白名单目标）；at 目标保证主手切换维度后仍能选中 mirror_dmg_target
execute as @a[tag=mirror_arrow_owner,limit=1] at @e[tag=mirror_arrow_hit,limit=1] run function plm:mirror/skill/crossbow/arrow/apply

# 残影 2 件套：齐射箭命中也算玩家远程命中；弩机/残影补箭不递归触发
scoreboard players set #can_ranged mirror_skill_tmp 1
execute if entity @s[tag=mirror_yingsui_arrow] as @a[tag=mirror_arrow_owner,limit=1] at @s run function plm:mirror/set/can/on_hit
scoreboard players set #can_ranged mirror_skill_tmp 0

tag @a remove mirror_arrow_owner
tag @e[tag=mirror_arrow_hit] remove mirror_arrow_hit
kill @s
