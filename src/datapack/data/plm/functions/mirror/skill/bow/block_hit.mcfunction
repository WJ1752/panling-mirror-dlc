# 镜花箭落地（bow/tick 每 5t 调用）：@s=箭，at @s。
# 打方块同样绽放：8 格内有敌 → 按槽位结算；无敌人 → 只放镜面粒子（impact_fx）。
# 打方块没有「原目标」，所以 #bow_block=1，resolve 不会补打原目标。
tag @s remove mirror_bloom_arrow
tag @e[tag=mirror_bloom_hit_arrow] remove mirror_bloom_hit_arrow
tag @s add mirror_bloom_hit_arrow

# 按 owner uuid 找射手（箭是玩家射出的，projectile_owner_uuid0..3 在射出时写入）
scoreboard players operation #bow_uid0 mirror_calc = @s projectile_owner_uuid0
scoreboard players operation #bow_uid1 mirror_calc = @s projectile_owner_uuid1
scoreboard players operation #bow_uid2 mirror_calc = @s projectile_owner_uuid2
scoreboard players operation #bow_uid3 mirror_calc = @s projectile_owner_uuid3
tag @a[tag=mirror_bloom_owner] remove mirror_bloom_owner
execute as @a if score @s player_uuid0 = #bow_uid0 mirror_calc if score @s player_uuid1 = #bow_uid1 mirror_calc if score @s player_uuid2 = #bow_uid2 mirror_calc if score @s player_uuid3 = #bow_uid3 mirror_calc run tag @s add mirror_bloom_owner

scoreboard players set #bow_block mirror_calc 1
execute unless entity @a[tag=mirror_bloom_owner,limit=1] run function plm:mirror/skill/bow/impact_fx
# 主人不在线：这支箭不会再进 resolve，趁实体还在时 reset 逐箭记分板（review #25）
execute unless entity @a[tag=mirror_bloom_owner,limit=1] run function plm:mirror/skill/bow/reset_arrow
execute unless entity @a[tag=mirror_bloom_owner,limit=1] run return 0

execute as @a[tag=mirror_bloom_owner,limit=1] at @e[tag=mirror_bloom_hit_arrow,limit=1] run function plm:mirror/skill/bow/resolve
tag @a[tag=mirror_bloom_owner] remove mirror_bloom_owner
