# @s = owner 玩家；执行位置 = 玩家当前位置。
# 1.20.1 没有函数宏，storage 的 pos 不能直接用于 execute positioned；用一个同 tick
# 临时 marker 作为“可写位置”的锚点：data modify entity Pos 从 storage 写入精确坐标，
# 然后 execute at 该 marker 结算，最后立刻 kill。marker 不跨 tick，不参与 5t 轮询。
kill @e[tag=mirror_zf_anchor]
summon minecraft:marker ~ ~ ~ {Tags:["mirror_zf_anchor","mirror_zf_anchor_new"]}
data modify entity @e[tag=mirror_zf_anchor_new,limit=1] Pos set from storage plm:mirror echo[0].pos
execute at @e[tag=mirror_zf_anchor_new,limit=1] run function plm:mirror/skill/furnace/twin/echo/resolve_at
kill @e[tag=mirror_zf_anchor_new]
