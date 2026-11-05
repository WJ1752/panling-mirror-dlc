execute store result storage plm:tbl tmp int 1 run scoreboard players get #t left
data modify block ~ ~ ~ Items[{Slot:0b}].Count set from storage plm:tbl tmp
