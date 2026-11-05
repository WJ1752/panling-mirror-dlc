# 血量阈值按最大生命百分比：50% 进镜中倒影；30% 进终局
scoreboard players operation #temp mirror_tmp = #boss mirror_boss_max
scoreboard players operation #temp mirror_tmp /= 2 int
scoreboard players operation #temp mirror_tmp2 = #boss mirror_boss_max
scoreboard players operation #temp mirror_tmp2 *= 2 int
scoreboard players operation #temp mirror_tmp2 += #boss mirror_boss_max
scoreboard players operation #temp mirror_tmp2 /= 10 int
execute if score #arena mirror_arena_active matches 1 if score #boss mirror_boss_hp matches ..0 run function plm:arena/phase/end
execute if score #arena mirror_arena_active matches 1 if score #arena mirror_boss_phase matches 1..2 if score #boss mirror_boss_hp matches 1.. if score #boss mirror_boss_hp <= #temp mirror_tmp run function plm:arena/phase/reflection/enter
execute if score #arena mirror_arena_active matches 1 if score #arena mirror_boss_phase matches 3 if score #boss mirror_boss_hp matches 1.. if score #boss mirror_boss_hp <= #temp mirror_tmp2 run function plm:arena/phase/final/enter
