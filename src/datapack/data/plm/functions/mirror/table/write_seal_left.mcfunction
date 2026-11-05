# 把 #t count 写回槽 1 的 Count（定影符按 1 个消耗后的余量）
execute store result storage plm:tbl tmp int 1 run scoreboard players get #t count
data modify block ~ ~ ~ Items[{Slot:1b}].Count set from storage plm:tbl tmp
