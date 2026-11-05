# 输入 #hit mirror_boss_damage，单位 1/10000 HP，与本体抵抗计算后的单位一致。
# 留下不足 1 HP 的余数，避免低伤/持续伤害因逐击取整消失。
execute unless score #hit mirror_boss_damage matches 1.. run return 0
# 单笔超出整场血量的部分不会改变结果；避免与余数相加溢出。
scoreboard players operation #maxhit mirror_boss_damage = #boss mirror_boss_max
scoreboard players operation #maxhit mirror_boss_damage *= #scale mirror_boss_damage
scoreboard players operation #hit mirror_boss_damage < #maxhit mirror_boss_damage
scoreboard players operation #fraction mirror_boss_damage += #hit mirror_boss_damage
scoreboard players operation #boss mirror_boss_damage = #fraction mirror_boss_damage
scoreboard players operation #boss mirror_boss_damage /= #scale mirror_boss_damage
scoreboard players operation #fraction mirror_boss_damage %= #scale mirror_boss_damage
execute if score #boss mirror_boss_damage matches 1.. run function plm:arena/boss/damage

execute if score #arena mirror_boss_phase matches 2 run scoreboard players operation #maxhit mirror_boss_damage = #boss mirror_boss_max
execute if score #arena mirror_boss_phase matches 2 run scoreboard players operation #maxhit mirror_boss_damage /= 10 int
execute if score #arena mirror_boss_phase matches 2 if score #boss mirror_boss_window_used >= #maxhit mirror_boss_damage run scoreboard players set #fraction mirror_boss_damage 0
