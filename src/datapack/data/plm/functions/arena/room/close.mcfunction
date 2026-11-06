# 必须在本场锚点上调用。下次启动由 load/defaults 重置每局计时器。
kill @e[type=minecraft:marker,tag=mirror_lightning,tag=mirror_arena_hazard,distance=..40]
function plm:arena/poison/clear_all
function plm:arena/summon/clear
kill @e[tag=mirror_arena_boss,distance=0..]
kill @e[type=minecraft:marker,tag=mirror_arena_point,distance=..40]
execute if score #arena mirror_arena_outcome matches 0 run title @a[tag=mirror_arena_member] title {"text":"挑战失败 · 可重新挑战","color":"red","bold":true}
execute as @a[tag=mirror_arena_member] run function plm:shadow/town_return
kill @e[type=minecraft:marker,tag=mirror_arena_anchor,distance=..0.1,limit=1]
function plm:arena/room/unregister
function plm:arena/room/release_chunks
data remove storage plm:arena room
