# 每 8s 召唤 4-6 只（上限 12）
execute if score #arena mirror_summon_timer matches 1.. run scoreboard players remove #arena mirror_summon_timer 1
execute if score #arena mirror_summon_timer matches ..0 run function plm:arena/summon/wave
