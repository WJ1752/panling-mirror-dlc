# 冷启动时中心实体可能比分布在四周的区块先加载，等整场可读后再推进或清理。
execute unless data storage plm:arena room.ready run function plm:arena/room/visible
execute unless data storage plm:arena room.ready if score #arena mirror_tmp matches 0 run return 0
execute unless data storage plm:arena room.ready run data modify storage plm:arena room.ready set value 1b
scoreboard players set #missing mirror_tick 0
function plm:arena/room/inside
execute unless entity @a[tag=mirror_arena_inside,distance=0..] run function plm:arena/room/close
execute unless score #arena mirror_arena_active matches 1 run return 0
function plm:arena/tick/active
scoreboard players add #arena mirror_tick 1
execute if score #arena mirror_tick matches 20.. run function plm:arena/tick/second
