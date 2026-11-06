# @s为玩家。marker或空地缺失时不标记快照，tick会在重生后重试。
function plm:shadow/town_return
execute if score @s shadow_tp matches 1 run scoreboard players operation @s shadow_died_seen = @s shadow_died
execute if score @s shadow_tp matches 1 run tellraw @s {"text":"你在影域中倒下，已回到城镇。","color":"yellow"}
