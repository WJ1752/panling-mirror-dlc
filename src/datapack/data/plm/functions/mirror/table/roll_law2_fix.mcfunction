# 第 2 条去重：排除 law1 与已锁镜律；不合法则 +1 回绕。
scoreboard players set #t ok 1
execute if score #t law2 = #t law1 run scoreboard players set #t ok 0
execute if score #t law2 = #t mirror_line1 run scoreboard players set #t ok 0
execute if score #t law2 = #t mirror_line2 run scoreboard players set #t ok 0
execute if score #t law2 = #t mirror_line3 run scoreboard players set #t ok 0
execute if score #t ok matches 1 run return 0
scoreboard players add #t law2 1
execute if score #t law2 matches 25.. run scoreboard players set #t law2 1
scoreboard players add #t tmp2 1
execute if score #t tmp2 matches 24.. run return 0
function plm:mirror/table/roll_law2_fix
