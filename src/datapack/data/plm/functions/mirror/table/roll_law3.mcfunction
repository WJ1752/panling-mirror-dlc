# 第 3 条：随机 1..24，排除第 1/2 条与已定影镜律
function plm:mirror/table/rand24
scoreboard players operation #t law3 = #t rand
scoreboard players set #t tmp2 0
function plm:mirror/table/roll_law3_fix
