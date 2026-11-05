# 照心套装 5t 维护：@s=玩家。
# 只做上限/过期/击杀叠层；碎镜由 heart_add 在满层瞬间触发。
# 死亡兜底：致死受击的 when_damaged 已清，这里再防一次（共享 clear 不清镜心）。
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_heart 0
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_heart_until 0
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_shatter 0
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_shatter_target 0
function plm:mirror/set/zhao/max
execute if score @s mirror_heart matches 1.. if score @s mirror_heart_until <= #sys mirror_game_time run scoreboard players set @s mirror_heart 0
execute if score @s mirror_heart matches 0 run scoreboard players set @s mirror_heart_until 0
execute if score @s mirror_heart > @s mirror_heart_max run scoreboard players operation @s mirror_heart = @s mirror_heart_max
# 没有照心件时清掉受击快照/治疗债务，避免换装后旧状态残留
execute if score @s mirror_heart_max matches 0 run scoreboard players set @s mirror_shatter 0
execute if score @s mirror_heart_max matches 0 run scoreboard players set @s mirror_shatter_target 0

# 击杀叠层：mirror_last_kill 由 plm:weapon/event/kill 写（任意来源的击杀都会写）。
# 只接受最近 10t 内的击杀，避免刚穿上照心时把旧击杀补算；mirror_heart_cd 记已处理的击杀时间戳。
scoreboard players operation #zhao_recent mirror_calc = #sys mirror_game_time
scoreboard players remove #zhao_recent mirror_calc 10
execute unless data entity @s {Health:0.0f} if score @s mirror_set_count matches 2.. if score @s mirror_last_kill >= #zhao_recent mirror_calc if score @s mirror_last_kill > @s mirror_heart_cd run function plm:mirror/set/zhao/heart_add
execute unless data entity @s {Health:0.0f} if score @s mirror_set_count matches 2.. if score @s mirror_last_kill >= #zhao_recent mirror_calc if score @s mirror_last_kill > @s mirror_heart_cd run scoreboard players operation @s mirror_heart_cd = @s mirror_last_kill
