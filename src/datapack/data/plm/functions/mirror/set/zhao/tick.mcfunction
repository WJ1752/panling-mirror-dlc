# 照心套装 5t tick（由 plm:mirror/set/tick 调用）
# 只处理有照心件或仍有镜心的玩家；没有照心时不会扫全服。
execute as @a[scores={mirror_set_a=1..}] run function plm:mirror/set/zhao/update
execute as @a[scores={mirror_heart=1..}] unless score @s mirror_set_a matches 1.. run function plm:mirror/set/zhao/update
# 有镜心时启动 2t 受击快照（函数自续约，没有镜心自动停）
execute if entity @a[scores={mirror_heart=1..}] run schedule function plm:mirror/set/zhao/snapshot 2t replace
