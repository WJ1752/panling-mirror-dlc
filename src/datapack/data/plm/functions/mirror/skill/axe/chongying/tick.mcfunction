# 重影 5t 入口
# 玩家持续时间：@a 全局，只递减一次（不能按维度展开，否则 3 倍速）。
execute as @a[scores={mirror_chongying_5ticks=1..}] run scoreboard players remove @s mirror_chongying_5ticks 1
# 影伤 marker：逐维度展开；tick_dim 内的 @e 用 distance=0.. 锚定执行维度。
execute in minecraft:overworld run function plm:mirror/skill/axe/chongying/tick_dim
execute in minecraft:the_nether run function plm:mirror/skill/axe/chongying/tick_dim
execute in minecraft:the_end run function plm:mirror/skill/axe/chongying/tick_dim
