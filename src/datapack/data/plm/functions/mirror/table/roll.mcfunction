# 掷骰：3 条不重复，且排除已定影镜律（lock 0/1/2；lock 3 在 polish 已拒绝）
# 已锁镜律读入 #t mirror_line1..3；未锁槽位保持 0，不会误排除。
scoreboard players set #t mirror_line1 0
scoreboard players set #t mirror_line2 0
scoreboard players set #t mirror_line3 0
execute if score #t lock matches 1.. store result score #t mirror_line1 run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1
execute if score #t lock matches 2.. store result score #t mirror_line2 run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line2

function plm:mirror/table/roll_law1
function plm:mirror/table/roll_law2
function plm:mirror/table/roll_law3
