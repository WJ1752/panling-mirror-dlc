# 首次镜主蓄势后才开始持械追击；只寻找本局场内队员，不交给原版AI误伤旁观者。
execute unless score #boss mirror_weapon matches 1..6 run return 0
execute if score #arena mirror_boss_phase matches 2 run return 0
execute if score #arena mirror_invuln matches 1.. run return 0
execute unless entity @a[tag=mirror_arena_inside,distance=0..] run return 0
execute if score #arena mirror_attack_cd matches 1.. run scoreboard players remove #arena mirror_attack_cd 1
# 小步追近，地面与头部可通过才移动；保留受击盒的无AI、抗击退和虚拟血量接口。
execute as @e[tag=mirror_arena_boss,limit=1] at @s unless entity @a[tag=mirror_arena_inside,distance=..2.4] facing entity @p[tag=mirror_arena_inside,distance=0..] feet positioned ^ ^ ^0.1 if block ~ ~ ~ minecraft:air if block ~ ~1 ~ minecraft:air run tp @s ~ ~ ~
execute at @e[tag=mirror_arena_boss,limit=1] if score #arena mirror_attack_cd matches ..0 if entity @a[tag=mirror_arena_inside,distance=..2.8] run function plm:arena/boss/attack_hit
