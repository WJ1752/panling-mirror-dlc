# 镜心受击快照：2t 一次，只处理有镜心的玩家；没有镜心时自动停表。
# 由 zhao/tick 在有镜心玩家时 schedule；本函数自己续约，避免 5t tick 粒度漏掉伤害。
execute as @a[scores={mirror_heart=1..}] run function plm:mirror/set/zhao/snapshot_one
execute if entity @a[scores={mirror_heart=1..}] run schedule function plm:mirror/set/zhao/snapshot 2t replace
