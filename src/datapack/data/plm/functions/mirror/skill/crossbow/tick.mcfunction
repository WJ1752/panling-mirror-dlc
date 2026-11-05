# 残影弩 5t 入口（由 plm:mirror/skill/tick 每 5t 调用）
# 玩家侧：三个维度各跑一次，用 `at @s if dimension <dim>` 过滤玩家（每个玩家只匹配一次）。
# 实体侧（弩机/弩机箭）：`execute in <dim>` 在 schedule/console 源下不会限制 @e，
# 逐维度调用会 3 倍递减寿命/攻击间隔。所以弩机只全局跑一次。
scoreboard players set #mirror_dim mirror_calc 0
execute in minecraft:overworld run function plm:mirror/skill/crossbow/tick_dim
scoreboard players set #mirror_dim mirror_calc 1
execute in minecraft:the_nether run function plm:mirror/skill/crossbow/tick_dim
scoreboard players set #mirror_dim mirror_calc 2
execute in minecraft:the_end run function plm:mirror/skill/crossbow/tick_dim

# 4) 留影弩机：寿命 / 主人死亡 / 定时射击（全局一次）
function plm:mirror/skill/crossbow/liuying/tick
# 5) 弩机箭：60t 或落地即清（Age 由箭自身累加，本函数 5t 检查一次）
execute as @e[type=arrow,tag=mirror_turret_arrow] if data entity @s {inGround:1b} run kill @s
execute as @e[type=arrow,tag=mirror_turret_arrow,nbt={Age:60..}] run kill @s
# 6) 技能箭直接结算循环：1t 自调度；这里做一次兜底重启（服务器 reload 丢 schedule 时）
execute if entity @e[type=arrow,tag=mirror_turret_arrow] run schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
execute if entity @e[type=arrow,tag=mirror_yingsui_arrow] run schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
execute if entity @e[type=arrow,tag=mirror_can_arrow] run schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
