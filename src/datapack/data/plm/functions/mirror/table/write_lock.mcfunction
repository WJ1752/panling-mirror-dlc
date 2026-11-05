execute store result storage plm:tbl tmp int 1 run scoreboard players get #t seal_lvl
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_lock set from storage plm:tbl tmp
