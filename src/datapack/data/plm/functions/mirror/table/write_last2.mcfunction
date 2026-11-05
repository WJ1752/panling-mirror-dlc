execute store result storage plm:tbl tmp int 1 run scoreboard players get #t law2
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last2 set from storage plm:tbl tmp
