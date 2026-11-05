# 0..99 随机数（1.20.1 没有 /random）：用 50% predicate 拼 7 位二进制
# 结果写 #rub mirror_rub_cd（0..99 均匀；100..127 重掷）
scoreboard players set #rub mirror_rub_cd 0
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 1
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 2
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 4
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 8
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 16
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 32
execute if predicate plm:arena/rand/coin run scoreboard players add #rub mirror_rub_cd 64
execute if score #rub mirror_rub_cd matches 100.. run function plm:mirror/skill/furnace/rub/roll
