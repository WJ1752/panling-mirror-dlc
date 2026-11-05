# 镜中倒影 · tick 入口（由 #minecraft:tick 驱动，每 tick 一次）
# 全局时间：所有 *_until / *_last 都存 gametime（tick），不用自建递增计时
execute store result score #sys mirror_game_time run time query gametime

# 镜武会话清理（每 tick 检查，避免 5t 轮询错过死亡/重登）
# 1) 死亡：DLC 自己的 deathCount objective，不依赖本体每 tick reset 的 player_death
execute as @a[scores={mirror_death=1..}] run function plm:mirror/skill/clear
execute as @a[scores={mirror_death=1..}] run scoreboard players set @s mirror_death 0
# 2) 重登：leave_game 在断线时 +1；上线首 tick 与上次快照比对
execute as @a unless score @s mirror_leave_seen matches 0.. run scoreboard players set @s mirror_leave_seen 0
execute as @a if score @s mirror_leave > @s mirror_leave_seen run function plm:mirror/skill/clear
execute as @a if score @s mirror_leave > @s mirror_leave_seen run scoreboard players operation @s mirror_leave_seen = @s mirror_leave

# 冷却倒计时（每 tick 减 1，10 tick 冷却）
execute as @a[scores={mirror_tbl_cool=1..}] run scoreboard players remove @s mirror_tbl_cool 1
execute as @a[scores={mirror_tbl_cool=..-1}] run scoreboard players set @s mirror_tbl_cool 0

# 镜映完美窗口：tick 倒计时（基础 10t=0.5s；明镜·早满值 +6t → 0.8s）
execute as @a[scores={mirror_parry_perfect=1..}] run scoreboard players remove @s mirror_parry_perfect 1
