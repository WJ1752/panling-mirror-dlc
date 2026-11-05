scoreboard players set #hit mirror_boss_damage 10240000
execute store result score #remaining mirror_boss_damage run data get entity @s Health 10000
scoreboard players operation #hit mirror_boss_damage -= #remaining mirror_boss_damage
execute if score #base_override mirror_boss_damage matches 1.. run scoreboard players operation #hit mirror_boss_damage = #base_override mirror_boss_damage
function plm:arena/hit/damage
