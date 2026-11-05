# 从箭的位置标记刚命中的白名单目标（@s=箭，at 箭）。
# 1.20.1 的 NBT 选择器不支持 HurtTime 数值范围，因此按“最近目标 + HurtTime 分数 >0”判定。
# 事件本身来自 player_hurt_entity；1t 的 HurtTime 衰减不应让命中丢失。
scoreboard players set #rng_ht mirror_calc 0
execute as @e[tag=monster,distance=..4,sort=nearest,limit=1] store result score #rng_ht mirror_calc run data get entity @s HurtTime
execute if score #rng_ht mirror_calc matches 1.. as @e[tag=monster,distance=..4,sort=nearest,limit=1] run tag @s add mirror_ranged_target
scoreboard players set #rng_ht mirror_calc 0
execute as @e[tag=mirror_boss,distance=..4,sort=nearest,limit=1] store result score #rng_ht mirror_calc run data get entity @s HurtTime
execute if score #rng_ht mirror_calc matches 1.. as @e[tag=mirror_boss,distance=..4,sort=nearest,limit=1] run tag @s add mirror_ranged_target
scoreboard players set #rng_ht mirror_calc 0
execute as @e[tag=mirror_summon,distance=..4,sort=nearest,limit=1] store result score #rng_ht mirror_calc run data get entity @s HurtTime
execute if score #rng_ht mirror_calc matches 1.. as @e[tag=mirror_summon,distance=..4,sort=nearest,limit=1] run tag @s add mirror_ranged_target
