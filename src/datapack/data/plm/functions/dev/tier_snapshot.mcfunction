# 测试夹具：原子地按 #dev mirror_set_tmp 重算套装分档并快照到 storage plm:dev tier。
# 5t tick 会用 #t mirror_set_tmp 反复重算残影/双生/拓印三套，测试分步读 @s 分数会读到别的套。
# 用法：scoreboard players set #dev mirror_set_tmp <0..5>
#       execute as <玩家> at <玩家> run function plm:dev/tier_snapshot
#       data get storage plm:dev tier -> {count, trueLaw, set4, tier}
scoreboard players operation #t mirror_set_tmp = #dev mirror_set_tmp
function plm:mirror/set/can/tier
data modify storage plm:dev tier set value {}
execute store result storage plm:dev tier.count int 1 run scoreboard players get @s mirror_set_count
execute store result storage plm:dev tier.trueLaw int 1 run scoreboard players get @s mirror_true_law
execute store result storage plm:dev tier.set4 int 1 run scoreboard players get @s mirror_set_4
execute store result storage plm:dev tier.tier int 1 run scoreboard players get @s mirror_set_tier
