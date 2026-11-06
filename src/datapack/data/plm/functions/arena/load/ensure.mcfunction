# 已存在的 objective 在 add 失败时保留分数；首次升级会补齐所有缺项。
function plm:arena/load/objectives
scoreboard players add #arena mirror_arena_run 0
execute if score #arena mirror_arena_run matches 0 run function plm:arena/load/defaults
execute unless data storage plm:arena receipts run data modify storage plm:arena receipts set value []
data modify storage plm:arena schema set value 4
