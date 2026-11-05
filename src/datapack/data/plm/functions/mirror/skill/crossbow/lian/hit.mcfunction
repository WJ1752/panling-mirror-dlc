# 连影 · 箭命中回调（advancement plm:mirror/crossbow/lian_hit；@s=射手，at 玩家）
# 只统计玩家自己射出的箭（tag=mirror_arrow + projectile_owner_uuid 四项匹配），
# 不再用全服 `@e[type=arrow,tag=mirror_arrow]` 裸找最近受伤怪。
# 计数核心在 lian/record：目标切换 / 5s 未命中清零；第 4 次命中触发重影。
# 弩机/齐射箭不挂 mirror_arrow（真实箭 0 伤害），由 arrow/hit_check 直接调用同一个 record。
advancement revoke @s only plm:mirror/crossbow/lian_hit
execute unless score @s job matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0

# 只在自己射出的箭附近找刚被命中的目标（白名单 monster / mirror_boss / mirror_summon）
tag @e[tag=monster] remove mirror_lian_hit_target
tag @e[tag=mirror_boss] remove mirror_lian_hit_target
tag @e[tag=mirror_summon] remove mirror_lian_hit_target
tag @e[type=arrow,tag=mirror_arrow] remove mirror_lian_own_arrow
scoreboard players operation #lian_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #lian_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #lian_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #lian_uid3 mirror_calc = @s player_uuid3
execute as @e[type=arrow,tag=mirror_arrow] if score @s projectile_owner_uuid0 = #lian_uid0 mirror_calc if score @s projectile_owner_uuid1 = #lian_uid1 mirror_calc if score @s projectile_owner_uuid2 = #lian_uid2 mirror_calc if score @s projectile_owner_uuid3 = #lian_uid3 mirror_calc run tag @s add mirror_lian_own_arrow
execute as @e[type=arrow,tag=mirror_lian_own_arrow] at @s run tag @e[tag=monster,nbt={HurtTime:10s},distance=..4,sort=nearest,limit=1] add mirror_lian_hit_target
execute as @e[type=arrow,tag=mirror_lian_own_arrow] at @s run tag @e[tag=mirror_boss,nbt={HurtTime:10s},distance=..4,sort=nearest,limit=1] add mirror_lian_hit_target
execute as @e[type=arrow,tag=mirror_lian_own_arrow] at @s run tag @e[tag=mirror_summon,nbt={HurtTime:10s},distance=..4,sort=nearest,limit=1] add mirror_lian_hit_target
tag @e[type=arrow,tag=mirror_lian_own_arrow] remove mirror_lian_own_arrow

# 确认目标后进入计数核心
execute unless entity @e[tag=monster,tag=mirror_lian_hit_target,limit=1] unless entity @e[tag=mirror_boss,tag=mirror_lian_hit_target,limit=1] unless entity @e[tag=mirror_summon,tag=mirror_lian_hit_target,limit=1] run return 0
function plm:mirror/skill/crossbow/lian/record_player

# 残影 2 件套的远程判定统一由 plm:mirror/ranged/hit 处理（普通箭/弩箭都会触发），
# 这里不再调用 can/on_hit，避免同一箭命中两次。

tag @e[tag=monster] remove mirror_lian_hit_target
tag @e[tag=mirror_boss] remove mirror_lian_hit_target
tag @e[tag=mirror_summon] remove mirror_lian_hit_target
