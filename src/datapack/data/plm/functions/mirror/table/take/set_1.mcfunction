# 把 #t tmp 写回槽 1 的 Count
execute store result storage plm:tbl tmp int 1 run scoreboard players get #t tmp
data modify block ~ ~ ~ Items[{Slot:1b}].Count set from storage plm:tbl tmp
