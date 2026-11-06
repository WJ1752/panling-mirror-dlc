# schedule 不保留调用位置，施工必须重新定位到这次创建的合法战房标记。
execute in minecraft:overworld at @e[type=minecraft:marker,tag=mirror_arena_build,limit=1] run function plm:arena/room/construct_finish
