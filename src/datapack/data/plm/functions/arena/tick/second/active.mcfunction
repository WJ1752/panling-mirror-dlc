# 每秒：冷却、颜色、阶段计时器、毒地/粒子
execute if score #arena mirror_lord_cd matches 1.. run scoreboard players remove #arena mirror_lord_cd 1
execute if score #arena mirror_color_rules matches 1 run function plm:arena/color/tick
execute if score #arena mirror_boss_phase matches 1 run function plm:arena/phase/shadow/second
execute if score #arena mirror_boss_phase matches 2 run function plm:arena/phase/lord/second
execute if score #arena mirror_boss_phase matches 3 run function plm:arena/phase/reflection/second
execute if score #arena mirror_boss_phase matches 4 run function plm:arena/phase/final/second
execute if score #arena mirror_color_rules matches 1 run function plm:arena/summon/particles
execute if score #arena mirror_boss_phase matches 4 run function plm:arena/poison/tick_players
