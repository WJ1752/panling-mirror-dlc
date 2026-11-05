execute store result storage plm:tbl tmp int 1 run scoreboard players get #t count
data modify block ~ ~ ~ Items[{Slot:8b}].Count set from storage plm:tbl tmp
