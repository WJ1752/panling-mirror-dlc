# 开发测试：同一 tick 起手+受击，必定落在完美窗口
# 用法：execute as <玩家> run function plm:dev/parry_test（需附近有 tag=parry_dummy 的怪）
effect give @s minecraft:instant_health 1 10
scoreboard players set @s mirror_parry 100
scoreboard players set @s mirror_parry_hp 2000
scoreboard players set @s mirror_parry_done 0
scoreboard players set @s mirror_parry_perfect 100
damage @s 6 minecraft:mob_attack by @e[tag=parry_dummy,limit=1]
