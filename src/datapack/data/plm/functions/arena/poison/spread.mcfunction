# 每轮最多处理 20 个旧毒格，每格只尝试一个随机邻居。
scoreboard players set #arena mirror_poison_timer 3
execute store result score #arena mirror_poison_need run data get storage plm:arena frontier
execute if score #arena mirror_poison_need matches 21.. run scoreboard players set #arena mirror_poison_need 20
execute if score #arena mirror_poison_need matches 1.. run function plm:arena/poison/spread_next
