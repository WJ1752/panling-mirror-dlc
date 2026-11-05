scoreboard players set #arena mirror_tick 0
execute if score #arena mirror_arena_active matches 1 run function plm:arena/tick/second/active
