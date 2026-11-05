# @s=箭；比较箭自身 Owner[0..3] 与 #rng_uid0..3（射手 player_uuid）。
# 匹配则打 mirror_arrow，并把 owner 写进箭的 projectile_owner_uuid0..3 供 ranged/hit 复用。
scoreboard players set #rng_o0 mirror_calc 0
scoreboard players set #rng_o1 mirror_calc 0
scoreboard players set #rng_o2 mirror_calc 0
scoreboard players set #rng_o3 mirror_calc 0
execute store result score #rng_o0 mirror_calc run data get entity @s Owner[0]
execute store result score #rng_o1 mirror_calc run data get entity @s Owner[1]
execute store result score #rng_o2 mirror_calc run data get entity @s Owner[2]
execute store result score #rng_o3 mirror_calc run data get entity @s Owner[3]
execute if score #rng_o0 mirror_calc = #rng_uid0 mirror_calc if score #rng_o1 mirror_calc = #rng_uid1 mirror_calc if score #rng_o2 mirror_calc = #rng_uid2 mirror_calc if score #rng_o3 mirror_calc = #rng_uid3 mirror_calc run tag @s add mirror_arrow
execute if entity @s[tag=mirror_arrow] run scoreboard players operation @s projectile_owner_uuid0 = #rng_uid0 mirror_calc
execute if entity @s[tag=mirror_arrow] run scoreboard players operation @s projectile_owner_uuid1 = #rng_uid1 mirror_calc
execute if entity @s[tag=mirror_arrow] run scoreboard players operation @s projectile_owner_uuid2 = #rng_uid2 mirror_calc
execute if entity @s[tag=mirror_arrow] run scoreboard players operation @s projectile_owner_uuid3 = #rng_uid3 mirror_calc
