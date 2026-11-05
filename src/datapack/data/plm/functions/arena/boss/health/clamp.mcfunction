execute if score #boss mirror_boss_hp > #boss mirror_boss_max run scoreboard players operation #boss mirror_boss_hp = #boss mirror_boss_max
execute if score #boss mirror_boss_hp matches ..-1 run scoreboard players set #boss mirror_boss_hp 0
