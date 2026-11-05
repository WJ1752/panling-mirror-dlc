data modify storage plm:domains scanned set value []
data modify storage plm:domains scan set value []
data modify storage plm:domains scan set from storage plm:domains tower_wins
execute if data storage plm:domains scan[0] run function plm:domains/tower/check_receipt
function plm:domains/tower/leave
