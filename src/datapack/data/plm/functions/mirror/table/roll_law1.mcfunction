# 第 1 条：随机 1..24，若撞上已定影镜律则顺序 +1 回绕，直到空位
function plm:mirror/table/rand24
scoreboard players operation #t law1 = #t rand
scoreboard players set #t tmp2 0
function plm:mirror/table/roll_law1_fix
