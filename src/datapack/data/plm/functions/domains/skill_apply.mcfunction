function pld:pre/damage/operation/effect/check
scoreboard players operation #skill ds_hp = @s entity_hurt_temp
scoreboard players operation #skill ds_hp /= #unit ds_hp
scoreboard players operation #skill ds_hp *= #scale ds_hp
execute if score #skill ds_hp matches 401.. run scoreboard players set #skill ds_hp 400
execute unless score #skill ds_hp matches 1.. run return 0
execute if entity @s[tag=dm_boss_fire] if score #fire ds_window matches 1.. as @a[tag=mirror_arena_damage_owner,tag=plm_d_fire,limit=1] if score @s dm_run = #fire dm_run run scoreboard players operation #fire ds_hp -= #skill ds_hp
execute if entity @s[tag=dm_boss_tomb] if score #tomb ds_window matches 1.. as @a[tag=mirror_arena_damage_owner,tag=plm_d_tomb,limit=1] if score @s dm_run = #tomb dm_run run scoreboard players operation #tomb ds_hp -= #skill ds_hp
execute if entity @s[tag=dm_boss_tower] if score #tower ds_window matches 1.. as @a[tag=mirror_arena_damage_owner,tag=plm_d_tower,limit=1] if score @s dm_run = #tower dm_run run scoreboard players operation #tower ds_hp -= #skill ds_hp
execute if entity @s[tag=dm_boss_valley] if score #valley ds_window matches 1.. as @a[tag=mirror_arena_damage_owner,tag=plm_d_valley,limit=1] if score @s dm_run = #valley dm_run run scoreboard players operation #valley ds_hp -= #skill ds_hp
execute if entity @s[tag=dm_boss_mountain] if score #mountain ds_window matches 1.. as @a[tag=mirror_arena_damage_owner,tag=plm_d_mountain,limit=1] if score @s dm_run = #mountain dm_run run scoreboard players operation #mountain ds_hp -= #skill ds_hp
