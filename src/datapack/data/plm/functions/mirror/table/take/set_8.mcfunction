# 把 #t tmp 写回槽 8 的 Count
execute store result storage plm:tbl tmp int 1 run scoreboard players get #t tmp
data modify block ~ ~ ~ Items[{Slot:8b}].Count set from storage plm:tbl tmp
