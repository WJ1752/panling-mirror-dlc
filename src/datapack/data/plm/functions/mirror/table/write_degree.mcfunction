execute store result storage plm:tbl tmp int 1 run scoreboard players get #t deg
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_degree set from storage plm:tbl tmp
