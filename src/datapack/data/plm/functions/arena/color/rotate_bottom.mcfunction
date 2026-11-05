# 底部每 20s：黑(1) -> 白(2) -> 黑
scoreboard players add #arena mirror_bottom_color 1
execute if score #arena mirror_bottom_color matches 3.. run scoreboard players set #arena mirror_bottom_color 1
scoreboard players set #arena mirror_bottom_timer 20
function plm:arena/panel/bottom
function plm:arena/color/retag
function plm:arena/summon/particles
execute positioned ~ ~ ~ run playsound minecraft:block.note_block.bell master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 0.8
title @a[tag=mirror_arena_inside,distance=0..] actionbar {"text":"底部阴阳轮换","color":"gray"}
