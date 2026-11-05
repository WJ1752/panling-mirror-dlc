data modify storage plm:domains scanned set value []
data modify storage plm:domains scan set value []
data modify storage plm:domains scan set from storage plm:domains mountain_wins
execute if data storage plm:domains scan[0] run function plm:domains/mountain/check_receipt
function plm:domains/mountain/leave
