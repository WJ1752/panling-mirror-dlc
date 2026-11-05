# 镜映伤害快照：每 2 tick（设计 §2.1.1）
# @a 是全局选择器（覆盖所有维度），这里的 data get 不依赖执行维度，只跑一次。
function plm:mirror/skill/snapshot_dim
schedule function plm:mirror/skill/snapshot 2t replace
