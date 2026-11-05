# 把 #t wp_left 写回槽 8 的 Count
execute store result storage plm:weapon take int 1 run scoreboard players get #t wp_left
data modify block ~ ~ ~ Items[{Slot:8b}].Count set from storage plm:weapon take
