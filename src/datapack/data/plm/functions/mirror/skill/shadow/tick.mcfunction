# 分影 5t 入口：主世界 / 下界 / 末地各执行一次 tick_dim。
# 注意：不带位置参数的 @e 是跨维度的（1.20.1 实测）；单靠 execute in 不会限制 @e。
# tick_dim 里每个选择器都带 distance=0..，把处理范围锚在执行维度，因此逐维度展开
# 只会让同一倒影在它所在的那个维度被处理一次，计时/攻击不会 3 倍推进。
execute in minecraft:overworld run function plm:mirror/skill/shadow/tick_dim
execute in minecraft:the_nether run function plm:mirror/skill/shadow/tick_dim
execute in minecraft:the_end run function plm:mirror/skill/shadow/tick_dim
