# 把 #t wp_left 写回槽 3 的 Count
execute store result storage plm:weapon take int 1 run scoreboard players get #t wp_left
data modify block ~ ~ ~ Items[{Slot:3b}].Count set from storage plm:weapon take
