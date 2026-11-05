# append bei_zhao
data modify storage plm:weapon entry set value {id:"bei_zhao",val:0}
execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
data modify storage plm:weapon entry.val set from storage plm:weapon val
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg append from storage plm:weapon entry
