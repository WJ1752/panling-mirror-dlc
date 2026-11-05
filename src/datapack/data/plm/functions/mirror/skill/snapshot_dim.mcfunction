# 单维度镜映快照：只处理正在架势中的玩家
execute as @a[scores={mirror_parry=1..}] store result score @s mirror_parry_hp run data get entity @s Health 100
