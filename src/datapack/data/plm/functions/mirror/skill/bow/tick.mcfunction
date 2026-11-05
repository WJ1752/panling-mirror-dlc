# 镜花弓 5t tick（由 plm:mirror/skill/tick 每 5t 调用）
# 只扫箭：`execute in` 在 schedule/console 源下不会把 @e 限制在目标维度，
# 逐维度调用会把箭按 3 倍递减/3 倍粒子。这里只调一次；block_hit 内部用 at @s 定位。
function plm:mirror/skill/bow/tick_dim
