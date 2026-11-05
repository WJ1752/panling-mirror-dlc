# 每 8s 召唤 3-5 只（上限 8）；每 10s 换武器
execute if score #arena mirror_summon_timer matches 1.. run scoreboard players remove #arena mirror_summon_timer 1
execute if score #arena mirror_summon_timer matches ..0 run function plm:arena/summon/phase3/wave
execute if score #arena mirror_weapon_timer matches 1.. run scoreboard players remove #arena mirror_weapon_timer 1
execute if score #arena mirror_weapon_timer matches ..0 run function plm:arena/phase/reflection/weapon_switch
