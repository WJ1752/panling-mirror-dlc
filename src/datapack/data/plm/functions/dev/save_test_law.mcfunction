# 测试夹具：把共享 scratch mirror_true_law / mirror_set_count 复制到专用分数。
# 5t tick 里 can/twin/rub 的 tier 会重算 mirror_set_count，读之前必须先快照。
scoreboard players operation @s mirror_test_true_law = @s mirror_true_law
scoreboard players operation @s mirror_test_set_count = @s mirror_set_count
