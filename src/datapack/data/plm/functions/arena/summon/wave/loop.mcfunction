scoreboard players add #arena mirror_wave_i 1
execute store result score #arena mirror_summon_count run execute if entity @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon]
execute if score #arena mirror_summon_count matches ..11 run function plm:arena/summon/one
execute if score #arena mirror_wave_i < #arena mirror_wave_count if score #arena mirror_summon_count matches ..11 run function plm:arena/summon/wave/loop
