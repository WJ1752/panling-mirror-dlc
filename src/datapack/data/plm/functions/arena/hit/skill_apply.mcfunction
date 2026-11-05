function pld:pre/damage/operation/effect/check
scoreboard players operation #hit mirror_boss_damage = @s entity_hurt_temp
execute unless score #arena mirror_arena_active matches 1 run return 0
execute unless score #arena mirror_invuln matches 0 run return 0
execute at @e[tag=mirror_arena_anchor,limit=1] positioned ~-24 ~ ~-24 as @a[tag=mirror_arena_damage_owner,tag=mirror_arena_inside,dx=47,dy=23,dz=47,limit=1] if score @s mirror_arena_run = #arena mirror_arena_run run function plm:arena/hit/skill_owner
