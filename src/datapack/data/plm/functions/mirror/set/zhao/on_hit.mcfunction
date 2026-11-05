# 照心命中入口（由 plm:mirror/set/on_hit 调用；@s=玩家，目标已打 plm_ctx_target）
# 2 件套的击杀叠层：优先在命中当 tick 抢一次（weapon/event/kill 已写 mirror_last_kill 时），
# 其余击杀由 zhao/tick 的 5t 兜底。mirror_heart_cd 记已处理的时间戳，避免重复。
execute unless score @s mirror_set_a matches 1.. run return 0
function plm:mirror/set/zhao/max
execute unless score @s mirror_set_count matches 2.. run return 0
execute unless score @s mirror_last_kill = #sys mirror_game_time run return 0
execute unless score @s mirror_last_kill > @s mirror_heart_cd run return 0
function plm:mirror/set/zhao/heart_add
scoreboard players operation @s mirror_heart_cd = @s mirror_last_kill
