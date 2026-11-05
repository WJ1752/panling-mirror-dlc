# 命中点镜面碎裂：执行位置就是命中点（resolve 由 execute at 箭 进入；block_hit 在箭上）。
# 不生成实体、不弹射、不留持久镜面。
particle minecraft:dust 0.45 0.9 1 1 ~ ~ ~ 0.6 0.5 0.6 0.02 24
particle minecraft:end_rod ~ ~ ~ 0.4 0.4 0.4 0.05 12
playsound minecraft:block.glass.break master @a ~ ~ ~ 0.7 1.6
