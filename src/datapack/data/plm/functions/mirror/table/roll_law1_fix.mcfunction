# 第 1 条去重：验证 #t law1 不在已锁镜律中；不合法则 +1 回绕。
scoreboard players set #t ok 1
execute if score #t law1 = #t mirror_line1 run scoreboard players set #t ok 0
execute if score #t law1 = #t mirror_line2 run scoreboard players set #t ok 0
execute if score #t law1 = #t mirror_line3 run scoreboard players set #t ok 0
execute if score #t ok matches 1 run return 0
scoreboard players add #t law1 1
execute if score #t law1 matches 25.. run scoreboard players set #t law1 1
scoreboard players add #t tmp2 1
execute if score #t tmp2 matches 24.. run return 0
function plm:mirror/table/roll_law1_fix
