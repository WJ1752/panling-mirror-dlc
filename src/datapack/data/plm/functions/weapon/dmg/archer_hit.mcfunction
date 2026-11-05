# 武器五纹 · 弓/弩命中侧结算入口（advancement plm:weapon/ranged_hit）
# advancement 条件：damage.type ∈ #minecraft:is_projectile 且 direct_entity.type = minecraft:arrow
# （排除雪球/鸡蛋/药水等 thrown，避免扔杂物触发整条五纹结算）。
# 上下文：@s = 射手。箭在命中时通常已经消失，所以：
#   1) 先用 ctx/arrow 打在箭上的 tag=mirror_arrow + 本体 set_shooter 写的 projectile_owner_uuid0..3 做射手匹配，
#      再用 4 格内 HurtTime>0 找目标（与 mirror/ranged/mark_target 同口径）
#   2) 找不到箭实体时退回 ctx/arrow 存在射手身上的「最近一箭」快照（48 格内目标；更远则无法定位，不猜）
# 目标条件 DMG 只在命中侧读取（射出时没有目标）。结果累加进 @s mirror_ctx_extra（百分点×10），
# 最后由 plm:weapon/dmg/archer_apply 走一次追加伤害。
advancement revoke @s only plm:weapon/ranged_hit
execute unless score @s job matches 1 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless score @s mirror_form matches 2..3 run return 0
# 不检查 SelectedItem：射完切物品不应让已经飞出的箭失去五纹结算（与 mirror/ranged/hit 一致）。

tag @e[tag=wp_ranged_arrow] remove wp_ranged_arrow
tag @e[tag=wp_ranged_cand] remove wp_ranged_cand
tag @e[tag=wp_ranged_hit_arrow] remove wp_ranged_hit_arrow
tag @e[tag=plm_ctx_target] remove plm_ctx_target

# 只认本玩家射出的真实箭：箭上的 projectile_owner_uuid0..3 由本体 set_shooter 在出膛时按 Owner[] 写入。
# 排除镜花/影随/弩机/残影等专属技能箭（它们有各自结算点，重复结算会多打一遍五纹）。
scoreboard players operation #rng_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #rng_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #rng_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #rng_uid3 mirror_calc = @s player_uuid3
execute as @e[type=arrow,tag=mirror_arrow] unless entity @s[tag=mirror_bloom_arrow] unless entity @s[tag=mirror_yingsui_arrow] unless entity @s[tag=mirror_turret_arrow] unless entity @s[tag=mirror_can_arrow] if score @s projectile_owner_uuid0 = #rng_uid0 mirror_calc if score @s projectile_owner_uuid1 = #rng_uid1 mirror_calc if score @s projectile_owner_uuid2 = #rng_uid2 mirror_calc if score @s projectile_owner_uuid3 = #rng_uid3 mirror_calc run tag @s add wp_ranged_arrow
execute as @e[tag=wp_ranged_arrow] at @s run function plm:weapon/dmg/archer_hit/mark
execute unless entity @e[tag=wp_ranged_cand,limit=1] if score @s mirror_last_ranged_until >= #sys mirror_game_time run function plm:weapon/dmg/archer_hit/fallback
execute unless entity @e[tag=wp_ranged_cand,limit=1] run return 0

# 多箭/多重射击时只取一个目标：离射手最近（单发时唯一候选），避免 `limit=1` 无 sort 的任意选择。
execute at @s run tag @e[tag=wp_ranged_cand,sort=nearest,limit=1] add plm_ctx_target
tag @e[tag=wp_ranged_cand] remove wp_ranged_cand

# 箭伤基数：取命中目标 3 格内最近的一支自己的箭，按 damage×速度 还原（与 mirror/ranged/hit 同口径）
execute at @e[tag=plm_ctx_target,limit=1] run tag @e[type=arrow,tag=wp_ranged_arrow,distance=..3,sort=nearest,limit=1] add wp_ranged_hit_arrow
scoreboard players set #temp player_cause_1damage 0
execute if entity @e[tag=wp_ranged_hit_arrow,limit=1] store result score #temp player_cause_1damage run data get entity @e[tag=wp_ranged_hit_arrow,limit=1] damage 10
# 箭速度默认 100（=×1.0）：arrow/speed 在 Motion 全 0 时会提前 return，不留下上一次的旧值
scoreboard players set #speed100 mirror_wtmp11 100
execute if entity @e[tag=wp_ranged_hit_arrow,limit=1] as @e[tag=wp_ranged_hit_arrow,limit=1] run function plm:mirror/skill/crossbow/arrow/speed
execute if entity @e[tag=wp_ranged_hit_arrow,limit=1] run scoreboard players operation #temp player_cause_1damage *= #speed100 mirror_wtmp11
execute if entity @e[tag=wp_ranged_hit_arrow,limit=1] run scoreboard players operation #temp player_cause_1damage /= #const100 mirror_calc
# 箭已消失，或地上旧箭 Motion=0（speed=0）导致基数归零：用出膛时存在射手身上的快照（×10）。
# 快照也没有就不结算——不把基数夹成 1 去伪造 0.1 HP 的伤害。
execute unless score #temp player_cause_1damage matches 1.. run scoreboard players operation #temp player_cause_1damage = @s mirror_last_ranged_dmg
execute unless score #temp player_cause_1damage matches 1.. run return 0

# 本次命中目标
# 目标 uid / 命中计数（同一玩家连续命中，续影、镜熟、镜痕都用它）
scoreboard players operation #wp mirror_wtmp = @s player_uid
execute as @e[tag=plm_ctx_target,limit=1] run function plm:weapon/on_hit/mark

# 续影：同一目标递增，切换目标清零（与近战 on_hit 同口径；这里在读取 DMG 之前维护）
execute unless score @s mirror_xu_streak matches -2147483648.. run scoreboard players set @s mirror_xu_streak 0
execute unless score @s mirror_xu_target matches -2147483648.. run scoreboard players set @s mirror_xu_target 0
execute unless score @s mirror_xu_target = @e[tag=plm_ctx_target,limit=1] mirror_uid run scoreboard players set @s mirror_xu_streak 0
scoreboard players operation @s mirror_xu_target = @e[tag=plm_ctx_target,limit=1] mirror_uid

scoreboard players set @s mirror_ctx_extra 0
scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 0
function plm:weapon/dmg/archer/po_xiao
function plm:weapon/dmg/archer/xu_ying
function plm:weapon/dmg/archer/zhui_ying
function plm:weapon/dmg/archer/lian_xing
function plm:weapon/dmg/archer/bei_zhao
function plm:weapon/dmg/archer/shuang_zhao
function plm:weapon/dmg/archer/jing_shu
function plm:weapon/dmg/archer/ying_ren
function plm:weapon/dmg/archer/su_feng

# FX（目标条件部分）：镜痕 +5% / 照隙 +5% / 双影 10%
function plm:weapon/fx/jing_hen
function plm:weapon/fx/zhao_xi
function plm:weapon/fx/shuang_ying
# 镜统固定小特效（弓/弩：镜花、残影）；以命中目标为圆心找候选，而不是射手位置
execute at @e[tag=plm_ctx_target,limit=1] run function plm:weapon/base/base_jing_hua
execute at @e[tag=plm_ctx_target,limit=1] run function plm:weapon/base/base_can_ying

# 追加伤害
execute if score @s mirror_ctx_extra matches 1.. run function plm:weapon/dmg/archer_apply
scoreboard players set @s mirror_ctx_extra 0

# 命中后状态：镜痕留痕 / 照隙上标记 / 借影快照 / 连星计数
function plm:weapon/fx/jing_hen/mark
function plm:weapon/fx/zhao_xi/proc
function plm:weapon/fx/jie_ying/snapshot
scoreboard players add @s mirror_hit_seq 1
execute if score @s mirror_hit_seq matches 3.. run scoreboard players set @s mirror_hit_seq 0
scoreboard players add @s mirror_xu_streak 1
execute if score @s mirror_xu_streak matches 4.. run scoreboard players set @s mirror_xu_streak 3
scoreboard players operation @s mirror_last_combat = #sys mirror_game_time

# plm_ctx_target 是跨子系统共用的临时 tag，必须清；其余 wp_ranged_* 由下一次进入时的清理回收。
tag @e[tag=plm_ctx_target] remove plm_ctx_target
