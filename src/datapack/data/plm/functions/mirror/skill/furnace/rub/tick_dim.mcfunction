# 拓印炉单维度 5t
# 本器形没有需要倒计时的内部状态：mirror_cd_a 由 plm:mirror/skill/tick 统一递减，
# 显形/定身/减速全部走原版 effect，印的持续也不需要计时。
# 印上限按 2 件套动态 3/5；set/rub/tier 同时做防御性收敛。
execute as @a run function plm:mirror/set/rub/tier
execute as @a[scores={mirror_rub_stack=..-1}] run scoreboard players set @s mirror_rub_stack 0

# Lore 每 5t 对齐一次：覆盖死亡 clear 等不经过 rub 加印/放印路径的分数变化。
# lore 内部只在手持 act:1 拓印镜炉时写物品，其他玩家直接 return。
execute as @a run function plm:mirror/skill/furnace/rub/lore
