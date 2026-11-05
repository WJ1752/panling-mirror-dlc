# 单维度玩家 5t 计时（由 plm:mirror/skill/tick 按三个维度各调一次）
# deathCount 在未死亡时可能没有分数；弩机 owner 比较需要明确的 0。
execute as @a unless score @s mirror_death matches 0.. run scoreboard players set @s mirror_death 0
execute as @a[scores={mirror_cd_a=1..}] run scoreboard players remove @s mirror_cd_a 1
execute as @a[scores={mirror_cd_b=1..}] run scoreboard players remove @s mirror_cd_b 1
execute as @a[scores={mirror_cd_int=1..}] run scoreboard players remove @s mirror_cd_int 1
# cast_lock 单位 tick；本函数 5t 跑一次，因此每次减 5（负值归零）
execute as @a[scores={mirror_cast_lock=1..}] run scoreboard players remove @s mirror_cast_lock 5
execute as @a[scores={mirror_cast_lock=..-1}] run scoreboard players set @s mirror_cast_lock 0
execute as @a[scores={mirror_mingjing=1..}] run scoreboard players remove @s mirror_mingjing 1
# 完美窗口 mirror_parry_perfect 单位是 tick，递减在 plm:tick/main 逐 tick 做，这里不再 5t 递减
execute as @a[scores={mirror_parry=1..}] run scoreboard players remove @s mirror_parry 1
# 自然到期（不是被近战打掉）：done 仍为 0 → 返还一半冷却
execute as @a[scores={mirror_parry=0,mirror_parry_done=0}] run function plm:mirror/skill/parry/expire
