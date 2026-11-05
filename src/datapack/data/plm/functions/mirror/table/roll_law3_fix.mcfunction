# 第 3 条去重：排除 law1/law2 与已锁镜律；不合法则 +1 回绕。
scoreboard players set #t ok 1
execute if score #t law3 = #t law1 run scoreboard players set #t ok 0
execute if score #t law3 = #t law2 run scoreboard players set #t ok 0
execute if score #t law3 = #t mirror_line1 run scoreboard players set #t ok 0
execute if score #t law3 = #t mirror_line2 run scoreboard players set #t ok 0
execute if score #t law3 = #t mirror_line3 run scoreboard players set #t ok 0
execute if score #t ok matches 1 run return 0
scoreboard players add #t law3 1
execute if score #t law3 matches 25.. run scoreboard players set #t law3 1
scoreboard players add #t tmp2 1
execute if score #t tmp2 matches 24.. run return 0
function plm:mirror/table/roll_law3_fix
