# 服务器重启初期实体可能稍晚于记分板加载。只在连续五秒找不到锚点时恢复。
scoreboard players add #missing mirror_tick 1
execute if score #missing mirror_tick matches ..99 run return 0
scoreboard players set #missing mirror_tick 0
# 没有房间记录的旧档只关状态，不在未经定位的坐标写方块。
execute unless data storage plm:arena room.pos run function plm:arena/room/unregister
execute if data storage plm:arena room{dim:"minecraft:overworld"} in minecraft:overworld summon minecraft:marker run function plm:arena/room/recover
execute if data storage plm:arena room{dim:"minecraft:the_nether"} in minecraft:the_nether summon minecraft:marker run function plm:arena/room/recover
execute if data storage plm:arena room{dim:"minecraft:the_end"} in minecraft:the_end summon minecraft:marker run function plm:arena/room/recover
