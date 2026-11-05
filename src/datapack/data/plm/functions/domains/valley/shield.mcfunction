execute if score #valley ds_window matches 1.. if data entity @s {Invulnerable:1b} run data merge entity @s {Invulnerable:0b,Glowing:1b}
execute unless score #valley ds_window matches 1.. unless data entity @s {Invulnerable:1b} run data merge entity @s {Invulnerable:1b,Glowing:0b}
