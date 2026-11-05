# MC 在 player_hurt_entity 之前将本次削去的吸收量记到真实攻击者，单位 0.1 HP。
# 各人独立记账，旁人的攻击、召唤物和环境损伤不会混入这个攻击者的伤害。
scoreboard players set #hit mirror_boss_damage 0
execute if score @s mirror_abs_dealt matches 1.. run scoreboard players operation #hit mirror_boss_damage = @s mirror_abs_dealt
scoreboard players operation #hit mirror_boss_damage -= @s mirror_abs_seen
scoreboard players operation #hit mirror_boss_damage *= #native_scale mirror_boss_damage
function plm:arena/hit/abs_snapshot
data modify entity @e[tag=mirror_arena_boss,limit=1] AbsorptionAmount set value 2048.0f
function plm:arena/hit/check_member
execute unless entity @s[tag=mirror_arena_inside] run return 0
execute unless score #arena mirror_invuln matches 0 run return 0
execute if score #arena mirror_is_ranged matches 0 run function plm:arena/hit/damage
execute if score #arena mirror_is_ranged matches 1 run function plm:arena/hit/ranged
