# 顶部每 15s：白(1) -> 赤(2) -> 青(3) -> 白
scoreboard players add #arena mirror_top_color 1
execute if score #arena mirror_top_color matches 4.. run scoreboard players set #arena mirror_top_color 1
scoreboard players set #arena mirror_top_timer 15
function plm:arena/panel/top
function plm:arena/color/retag
function plm:arena/summon/particles
execute positioned ~ ~23 ~ run playsound minecraft:block.note_block.bell master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 1.2
title @a[tag=mirror_arena_inside,distance=0..] actionbar {"text":"顶部灯色轮换","color":"gray"}
