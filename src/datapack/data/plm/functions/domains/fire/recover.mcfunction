data modify storage plm:domains scanned set value []
data modify storage plm:domains scan set value []
data modify storage plm:domains scan set from storage plm:domains fire_wins
execute if data storage plm:domains scan[0] run function plm:domains/fire/check_receipt
function plm:domains/fire/leave
