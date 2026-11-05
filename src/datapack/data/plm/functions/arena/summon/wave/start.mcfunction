function plm:arena/rand/4_6
scoreboard players operation #arena mirror_wave_count = #rng mirror_rand
scoreboard players set #arena mirror_wave_i 0
function plm:arena/summon/wave/loop
