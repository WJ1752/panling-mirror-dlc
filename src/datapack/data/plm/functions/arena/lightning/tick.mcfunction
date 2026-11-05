execute if score #arena mirror_lightning_warn matches 1.. run scoreboard players remove #arena mirror_lightning_warn 1
execute if score #arena mirror_lightning_warn matches 0 if entity @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run function plm:arena/lightning/strike
execute at @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..70,limit=1] run particle minecraft:end_rod ~0.5 ~0.2 ~0.5 1.0 0.1 1.0 0.02 10
