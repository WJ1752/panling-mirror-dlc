# 由影域入城/重登流程以玩家为 @s 调用，按本人的 arena_run 派发断线收据。
data modify storage plm:arena scanned set value []
data modify storage plm:arena scan set value []
data modify storage plm:arena scan set from storage plm:arena receipts
execute if data storage plm:arena scan[0] run function plm:arena/reward/recover_one
data modify storage plm:arena receipts set from storage plm:arena scanned
data remove storage plm:arena scan
data remove storage plm:arena scanned
