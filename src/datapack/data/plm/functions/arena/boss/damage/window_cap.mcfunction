# 镜主 5s 窗口上限：cap = max * 10 / 100；damage 不超过 cap - used
# 用 #boss 的 mirror_tmp / mirror_tmp2 两个已声明 objective。
scoreboard players operation #boss mirror_tmp = #boss mirror_boss_max
scoreboard players operation #boss mirror_tmp *= 10 int
scoreboard players operation #boss mirror_tmp /= 100 int

scoreboard players operation #boss mirror_tmp2 = #boss mirror_tmp
scoreboard players operation #boss mirror_tmp2 -= #boss mirror_boss_window_used

# 已经打满/超出：本次伤害归零
execute if score #boss mirror_tmp2 matches ..0 run scoreboard players set #boss mirror_boss_damage 0
# 超出剩余：钳到剩余
execute if score #boss mirror_boss_damage > #boss mirror_tmp2 run scoreboard players operation #boss mirror_boss_damage = #boss mirror_tmp2
# 累计本窗口已用
scoreboard players operation #boss mirror_boss_window_used += #boss mirror_boss_damage
