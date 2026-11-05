# 单维度：清掉 #shadow_owner 的旧倒影（分影上限 1，重放时顶掉旧倒影）
# distance=0.. 锚在执行维度：start 会按三个维度各调一次，合起来清掉所有维度；
# 裸 @e 跨维度，若不加锚点，第一次调用就会清空全部，后两次只是空跑。
execute as @e[tag=mirror_shadow,distance=0..] if score @s mirror_shadow_owner = #shadow_owner mirror_skill_tmp run kill @s
