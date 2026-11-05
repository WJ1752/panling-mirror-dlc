scoreboard players set #hit ds_hp 1
execute if score @s attack_damage1 matches 10.. run scoreboard players operation #hit ds_hp = @s attack_damage1
execute if score @s attack_damage1 matches 10.. run scoreboard players operation #hit ds_hp /= 10 int
