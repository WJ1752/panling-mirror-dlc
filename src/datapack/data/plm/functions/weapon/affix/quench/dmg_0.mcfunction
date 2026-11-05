# 只改 mirror_dmg[0].val
function plm:weapon/affix/roll_val
execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[0].val set from storage plm:weapon val
