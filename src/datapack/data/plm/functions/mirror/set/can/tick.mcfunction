# 残影套装 5t（由 plm:mirror/set/tick 调用，顶层是 console/schedule 源）
# 1) 逐玩家刷新 2/4/真影律分档与弩机上限
# 2) 4 件套齐射装填 buff：Quick Charge 3 的施加 / 还原
# 3) 2 件套残影视觉队列（storage，不常驻实体）
# 防御：远程命中标记不应跨 tick 残留（正常调用在同一个函数链里已清 0）
scoreboard players set #can_ranged mirror_skill_tmp 0
execute as @a run function plm:mirror/set/can/tick_player
function plm:mirror/set/can/echo_tick
