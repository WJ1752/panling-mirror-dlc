# 条目结算：@s = owner 玩家；执行维度 = 条目所在维度（玩家当前维度）；执行位置 = 源位置。
# 先 at @s 取玩家位置，再交给 resolve_anchor_at 生成同 tick 临时 anchor。
execute at @s run function plm:mirror/skill/furnace/twin/echo/resolve_anchor_at
