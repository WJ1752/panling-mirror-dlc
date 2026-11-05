execute store result storage plm:tbl tmp int 1 run scoreboard players get #t law3
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line3 set from storage plm:tbl tmp
