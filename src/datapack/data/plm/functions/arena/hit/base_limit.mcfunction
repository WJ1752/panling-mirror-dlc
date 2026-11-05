function pld:system/warrior_attack/attribute/atk_sp/update
function pld:system/warrior_attack/attack_cool/get_multiplier
scoreboard players operation #temp entity_hurt_temp = @s attack_damage1
scoreboard players operation #temp entity_hurt_temp *= 10 int
scoreboard players operation #temp entity_hurt_temp *= attack_multiplier int
scoreboard players operation #temp entity_hurt_temp /= 100 int
execute as @e[tag=mirror_arena_boss,tag=warrior_tag,limit=1] run function plm:arena/hit/base_limit_target
