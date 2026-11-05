# Boss 虚拟血量伤害入口（整数 HP）
# 输入：#boss mirror_boss_damage = 本次伤害 HP（正数扣血，负数回血）
# 镜主 phase 2（5s 蓄势窗口）应用“每窗口 10% 最大生命”上限；
# 影主/镜中倒影/终局不钳制。伤害结算后同步 bossbar。
execute if score #arena mirror_boss_phase matches 2 run function plm:arena/boss/damage/window_cap
scoreboard players operation #boss mirror_boss_hp -= #boss mirror_boss_damage
function plm:arena/boss/health/clamp
execute store result bossbar plm:mirror_boss value run scoreboard players get #boss mirror_boss_hp
