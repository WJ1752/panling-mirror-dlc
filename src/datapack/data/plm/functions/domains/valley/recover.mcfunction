data modify storage plm:domains scanned set value []
data modify storage plm:domains scan set value []
data modify storage plm:domains scan set from storage plm:domains valley_wins
execute if data storage plm:domains scan[0] run function plm:domains/valley/check_receipt
function plm:domains/valley/leave
