# 重影单维度 5t：影伤队列
# 每个选择器都必须带 distance=0..：在 schedule/console 源下，裸 @e 不按执行维度过滤，
# tick 的三次逐维度调用会命中同一个 marker，把 due 以 3 倍速递减（实测 6 → 约 12t 结算）。
# distance=0.. 把匹配锚在执行维度，每个 marker 只在自己的维度被处理一次。
execute as @e[tag=mirror_shadow_hit,distance=0..] run scoreboard players remove @s mirror_shadow_hit_due 1
execute as @e[tag=mirror_shadow_hit,distance=0..,scores={mirror_shadow_hit_due=..0}] at @s run function plm:mirror/skill/axe/chongying/resolve
