# 单个持镜心玩家的 2t 快照：@s=玩家。
# mirror_shatter_target 存“受击前 Health×100”，供 when_damaged 计算本次伤害。
# 债务只在 when_damaged 里偿还（那时生命已被扣过，不会把 instant_health 浪费在满血上）。
execute store result score @s mirror_shatter_target run data get entity @s Health 100
