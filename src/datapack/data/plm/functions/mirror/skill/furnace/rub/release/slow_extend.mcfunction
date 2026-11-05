# 亡灵定身的后半段（0.5s）：release/victim 命中时 schedule 10t 调用。
# 1.20.1 的 /data modify entity 会把 Amplifier -1b(=255) 归一成 0b，无法用改 Duration
# 的方式凑 1.5s；这里用第二次 effect give（1s, 255）把总时长接成 30t。
# 三种维度都要处理：schedule 的执行源默认在主世界，跨维度目标不会被裸 @e 选中。
execute in minecraft:overworld as @e[tag=rub_slow_undead] run effect give @s minecraft:slowness 1 255 true
execute in minecraft:the_nether as @e[tag=rub_slow_undead] run effect give @s minecraft:slowness 1 255 true
execute in minecraft:the_end as @e[tag=rub_slow_undead] run effect give @s minecraft:slowness 1 255 true
execute in minecraft:overworld run tag @e[tag=rub_slow_undead] remove rub_slow_undead
execute in minecraft:the_nether run tag @e[tag=rub_slow_undead] remove rub_slow_undead
execute in minecraft:the_end run tag @e[tag=rub_slow_undead] remove rub_slow_undead
