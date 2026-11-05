execute if score #arena mirror_top_timer matches 1.. run scoreboard players remove #arena mirror_top_timer 1
execute if score #arena mirror_top_timer matches ..0 run function plm:arena/color/rotate_top
execute if score #arena mirror_bottom_timer matches 1.. run scoreboard players remove #arena mirror_bottom_timer 1
execute if score #arena mirror_bottom_timer matches ..0 run function plm:arena/color/rotate_bottom
