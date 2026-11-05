# oldest 的循环体（@s=弩机）；#old = 当前最小剩余寿命
execute if score @s mirror_turret_5ticks < #old mirror_wtmp10 run tag @e[tag=mirror_turret_old] remove mirror_turret_old
execute if score @s mirror_turret_5ticks < #old mirror_wtmp10 run tag @s add mirror_turret_old
execute if score @s mirror_turret_5ticks < #old mirror_wtmp10 run scoreboard players operation #old mirror_wtmp10 = @s mirror_turret_5ticks
