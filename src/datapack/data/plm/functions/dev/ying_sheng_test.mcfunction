# 测试夹具：原子地把三条共享冷却设为 20、跑一次映声，并快照结果。
# player_tick_dim 每 5t 递减 mirror_cd_a/b/int；分步设置/读取会与 tick 竞争（20 可能变成 13）。
# 要求：@s 的 wp_affix_fx_ying_sheng 已按测试设定（1000 = 100%）。
# 用法：execute as <玩家> at <玩家> run function plm:dev/ying_sheng_test
#       data get storage plm:dev ying_sheng -> {a,b,i}
scoreboard players set @s mirror_cd_a 20
scoreboard players set @s mirror_cd_b 20
scoreboard players set @s mirror_cd_int 20
function plm:weapon/fx/ying_sheng
data modify storage plm:dev ying_sheng set value {}
execute store result storage plm:dev ying_sheng.a int 1 run scoreboard players get @s mirror_cd_a
execute store result storage plm:dev ying_sheng.b int 1 run scoreboard players get @s mirror_cd_b
execute store result storage plm:dev ying_sheng.i int 1 run scoreboard players get @s mirror_cd_int
