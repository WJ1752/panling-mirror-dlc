# 闪电每 5s；毒地每 3s 扩散；武器每 10s
execute if score #arena mirror_lightning_timer matches 1.. run scoreboard players remove #arena mirror_lightning_timer 1
execute if score #arena mirror_lightning_timer matches ..0 run function plm:arena/lightning/warn
execute if score #arena mirror_poison_timer matches 1.. run scoreboard players remove #arena mirror_poison_timer 1
execute if score #arena mirror_poison_timer matches ..0 run function plm:arena/poison/spread
execute if score #arena mirror_weapon_timer matches 1.. run scoreboard players remove #arena mirror_weapon_timer 1
execute if score #arena mirror_weapon_timer matches ..0 run function plm:arena/phase/reflection/weapon_switch
