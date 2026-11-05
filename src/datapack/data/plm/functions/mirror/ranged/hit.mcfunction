# 通用远程命中入口（advancement plm:mirror/ranged/hit；@s=射手，at 玩家）。
# 覆盖普通弓/弩的真实箭；镜花箭、影随/弩机/残影技能箭有各自的结算点，这里排除。
# 依赖 plm:weapon/ctx/arrow 给真实箭打的 mirror_arrow + projectile_owner_uuid0..3。
# 只服务 2/4 件套的远程触发：裂影影伤、镜花花影、残影残影。
advancement revoke @s only plm:mirror/ranged/hit
execute unless score @s job matches 1 run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
# 只认本体的镜弓/镜弩形态（form 2=弓 / 3=弩）；近战形态不处理
execute unless score @s mirror_form matches 2..3 run return 0

# 找自己射出的真实箭：排除已由专属入口处理的箭，避免重复结算。
tag @e[tag=mirror_ranged_own] remove mirror_ranged_own
tag @e[tag=mirror_ranged_target] remove mirror_ranged_target
tag @e[tag=mirror_ranged_hit_arrow] remove mirror_ranged_hit_arrow

# owner 匹配：箭的 projectile_owner_uuid0..3 == 玩家 player_uuid0..3
scoreboard players operation #rng_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #rng_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #rng_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #rng_uid3 mirror_calc = @s player_uuid3
tag @e[tag=mirror_ranged_own] remove mirror_ranged_own
execute as @e[type=arrow,tag=mirror_arrow] unless entity @s[tag=mirror_bloom_arrow] unless entity @s[tag=mirror_yingsui_arrow] unless entity @s[tag=mirror_turret_arrow] unless entity @s[tag=mirror_can_arrow] if score @s projectile_owner_uuid0 = #rng_uid0 mirror_calc if score @s projectile_owner_uuid1 = #rng_uid1 mirror_calc if score @s projectile_owner_uuid2 = #rng_uid2 mirror_calc if score @s projectile_owner_uuid3 = #rng_uid3 mirror_calc run tag @s add mirror_ranged_own
# 真实箭已在命中时消失：用 ctx/arrow 存到射手的最近一箭快照回退
execute unless entity @e[tag=mirror_ranged_own,limit=1] if score @s mirror_last_ranged_until >= #sys mirror_game_time run function plm:mirror/ranged/fallback
execute unless entity @e[tag=mirror_ranged_own,limit=1] run return 0

# 命中目标：箭 4 格内刚受伤（HurtTime>0）的白名单怪
execute as @e[type=arrow,tag=mirror_ranged_own] at @s run function plm:mirror/ranged/mark_target
execute unless entity @e[tag=mirror_ranged_target,limit=1] run return 0

# 取离命中目标最近的一支自己的箭；用它身上的 damage/speed 还原实际箭伤
execute at @e[tag=mirror_ranged_target,limit=1] run tag @e[type=arrow,tag=mirror_ranged_own,distance=..2,sort=nearest,limit=1] add mirror_ranged_hit_arrow
execute unless entity @e[tag=mirror_ranged_hit_arrow,limit=1] run return 0
scoreboard players set #temp player_cause_1damage 0
execute store result score #temp player_cause_1damage run data get entity @e[tag=mirror_ranged_hit_arrow,limit=1] damage 10
execute as @e[tag=mirror_ranged_hit_arrow,limit=1] run function plm:mirror/skill/crossbow/arrow/speed
# 不衰减箭（技能箭/测试固定 3.0）与 hit_check 同口径
execute if entity @e[tag=mirror_ranged_hit_arrow,limit=1,tag=mirror_no_falloff] run scoreboard players set #speed100 mirror_wtmp11 300
scoreboard players operation #temp player_cause_1damage *= #speed100 mirror_wtmp11
scoreboard players operation #temp player_cause_1damage /= #const100 mirror_calc
execute if score #temp player_cause_1damage matches ..0 run scoreboard players set #temp player_cause_1damage 1
# 暴击标记交给裂影影伤判定（仅弓 form=2 会消费；箭自身 crit 已在原伤害里）
scoreboard players set @s mirror_axe_2_crit 0
execute store result score @s mirror_axe_2_crit run data get entity @e[tag=mirror_ranged_hit_arrow,limit=1] crit

# 裂影 2 件套：对本次命中的目标追加 15% 影伤（每箭一次）
tag @e[tag=plm_ctx_target] remove plm_ctx_target
tag @e[tag=mirror_ranged_target,limit=1] add plm_ctx_target
execute if entity @e[tag=plm_ctx_target,limit=1] run function plm:mirror/set/lie/on_hit
tag @e[tag=plm_ctx_target] remove plm_ctx_target

# 残影 2 件套：普通弓/弩箭也算远程命中
scoreboard players set #can_ranged mirror_skill_tmp 1
function plm:mirror/set/can/on_hit
scoreboard players set #can_ranged mirror_skill_tmp 0

# 镜花 2 件套：普通弓箭命中 +1 花影（专属镜花箭仍走 bloom_hit/resolve）
execute if entity @e[tag=mirror_ranged_hit_arrow,limit=1,tag=mirror_jinghua_arrow] at @e[tag=mirror_ranged_hit_arrow,limit=1] run function plm:mirror/set/jing_hua/on_normal_hit

tag @e[tag=mirror_ranged_own] remove mirror_ranged_own
tag @e[tag=mirror_ranged_target] remove mirror_ranged_target
tag @e[tag=mirror_ranged_hit_arrow] remove mirror_ranged_hit_arrow
