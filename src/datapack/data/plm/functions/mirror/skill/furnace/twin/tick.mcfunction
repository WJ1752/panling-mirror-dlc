# 双生炉 5t 入口
# 镜匣元素记忆：@a 全局，只递减一次。
execute as @a[scores={mirror_box_5ticks=1..}] run scoreboard players remove @s mirror_box_5ticks 1
execute as @a[scores={mirror_box_remember=1,mirror_box_5ticks=..0}] run scoreboard players set @s mirror_box_remember 0
# 倒影阵延迟：storage plm:mirror echo 队列，每 5t 处理一次；不扫实体，单次上限 32。
function plm:mirror/skill/furnace/twin/echo/tick
