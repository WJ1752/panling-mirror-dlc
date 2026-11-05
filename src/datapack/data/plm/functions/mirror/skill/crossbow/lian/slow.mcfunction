# 连影 · 重影箭的缓慢（1t 后由 schedule 调用；服务端 tick 上下文）
# 上下文：@e[tag=monster,tag=mirror_lian_slow_target] = 目标。
# /effect 的最小持续时间是 1s（20t），设计写 10t；amplifier 255 在这里不会被压成 0。
effect give @e[tag=monster,tag=mirror_lian_slow_target,limit=1] minecraft:slowness 1 255 true
tag @e[tag=monster] remove mirror_lian_slow_target
