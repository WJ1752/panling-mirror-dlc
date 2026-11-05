# 镜花命中入口：advancement plm:mirror/bow/bloom_hit 的 reward 函数（@s=射手）。
# 1.20.1 实测：player_hurt_entity 触发时箭仍在命中点；致命一击时目标已移除，但箭还在。
# 所以先用「箭 2 格内有刚受伤的怪」精确找箭；找不到（致命一击）再退化为 owner 匹配的箭。
# 伤害/溅射由 resolve 统一结算；这里不做任何生成新箭/实体。
advancement revoke @s only plm:mirror/bow/bloom_hit
execute unless score @s job matches 1 run return 0

scoreboard players operation #bow_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #bow_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #bow_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #bow_uid3 mirror_calc = @s player_uuid3

tag @e[tag=mirror_bloom_hit_arrow] remove mirror_bloom_hit_arrow
# 命中实体：monster / mirror_boss / mirror_summon（CONTRACT §4 白名单）
execute as @e[type=arrow,tag=mirror_bloom_arrow] at @s if score @s projectile_owner_uuid0 = #bow_uid0 mirror_calc if score @s projectile_owner_uuid1 = #bow_uid1 mirror_calc if score @s projectile_owner_uuid2 = #bow_uid2 mirror_calc if score @s projectile_owner_uuid3 = #bow_uid3 mirror_calc if entity @e[tag=monster,nbt={HurtTime:10s},distance=..2,limit=1] run tag @s add mirror_bloom_hit_arrow
execute as @e[type=arrow,tag=mirror_bloom_arrow] at @s if score @s projectile_owner_uuid0 = #bow_uid0 mirror_calc if score @s projectile_owner_uuid1 = #bow_uid1 mirror_calc if score @s projectile_owner_uuid2 = #bow_uid2 mirror_calc if score @s projectile_owner_uuid3 = #bow_uid3 mirror_calc if entity @e[tag=mirror_boss,nbt={HurtTime:10s},distance=..2,limit=1] run tag @s add mirror_bloom_hit_arrow
execute as @e[type=arrow,tag=mirror_bloom_arrow] at @s if score @s projectile_owner_uuid0 = #bow_uid0 mirror_calc if score @s projectile_owner_uuid1 = #bow_uid1 mirror_calc if score @s projectile_owner_uuid2 = #bow_uid2 mirror_calc if score @s projectile_owner_uuid3 = #bow_uid3 mirror_calc if entity @e[tag=mirror_summon,nbt={HurtTime:10s},distance=..2,limit=1] run tag @s add mirror_bloom_hit_arrow
# 致命一击：原目标已不在，但仍要绽放到范围内其它敌人。
# 退化路径只取离玩家最近的一支自己的箭，不能把 owner 的所有在飞箭都打上 tag
# （否则 resolve 的 limit=1 可能在另一支箭的位置结算，并误伤其它箭）。
execute unless entity @e[tag=mirror_bloom_hit_arrow,limit=1] as @e[type=arrow,tag=mirror_bloom_arrow,limit=1,sort=nearest] if score @s projectile_owner_uuid0 = #bow_uid0 mirror_calc if score @s projectile_owner_uuid1 = #bow_uid1 mirror_calc if score @s projectile_owner_uuid2 = #bow_uid2 mirror_calc if score @s projectile_owner_uuid3 = #bow_uid3 mirror_calc run tag @s add mirror_bloom_hit_arrow

execute unless entity @e[tag=mirror_bloom_hit_arrow,limit=1] run return 0
# 裂影 2 件套：对原箭命中的目标追加一次 15% 影伤（原箭只触发一次，绽放溅射不重复触发）
tag @e[tag=plm_ctx_target] remove plm_ctx_target
execute at @e[tag=mirror_bloom_hit_arrow,limit=1] run tag @e[tag=monster,nbt={HurtTime:10s},distance=..2,sort=nearest,limit=1] add plm_ctx_target
execute at @e[tag=mirror_bloom_hit_arrow,limit=1] unless entity @e[tag=plm_ctx_target,limit=1] run tag @e[tag=mirror_boss,nbt={HurtTime:10s},distance=..2,sort=nearest,limit=1] add plm_ctx_target
execute at @e[tag=mirror_bloom_hit_arrow,limit=1] unless entity @e[tag=plm_ctx_target,limit=1] run tag @e[tag=mirror_summon,nbt={HurtTime:10s},distance=..2,sort=nearest,limit=1] add plm_ctx_target
execute if entity @e[tag=plm_ctx_target,limit=1] run function plm:mirror/skill/bow/lie_proc
scoreboard players set #bow_block mirror_calc 0
execute at @e[tag=mirror_bloom_hit_arrow,limit=1] run function plm:mirror/skill/bow/resolve
