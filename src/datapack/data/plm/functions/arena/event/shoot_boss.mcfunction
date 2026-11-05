advancement revoke @s only plm:arena/shoot_boss
scoreboard players set #arena mirror_is_ranged 1
execute if score #arena mirror_arena_active matches 1 at @e[tag=mirror_arena_anchor,limit=1] run function plm:arena/hit/native
