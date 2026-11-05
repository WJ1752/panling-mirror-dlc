# 仅造成正伤害的实际远程命中可在 CD 0 时变身，触发弹不扣虚拟 HP。
execute unless score #hit mirror_boss_damage matches 1.. run return 0
scoreboard players set #arena mirror_hit_branch 0
execute if score #arena mirror_boss_phase matches 1 if score #arena mirror_lord_cd matches 0 run scoreboard players set #arena mirror_hit_branch 1
execute if score #arena mirror_hit_branch matches 1 run function plm:arena/hit/lord_trigger
execute if score #arena mirror_hit_branch matches 0 run function plm:arena/hit/damage
