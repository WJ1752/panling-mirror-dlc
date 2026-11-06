# 延后一tick，确保build入口申请的战场区块已加载。
execute unless entity @e[type=minecraft:marker,tag=plm_shadow_arena_center,distance=..0.1,limit=1] run return 0
function plm:arena/room/visible
execute if score #arena mirror_tmp matches 0 run schedule function plm:arena/room/construct_resume 1t replace
execute if score #arena mirror_tmp matches 0 run return 0
# 清空内腔分两层，避免单条 fill 超过原版 32,768 方块限制。
fill ~-23 ~ ~-23 ~22 ~11 ~22 minecraft:air
fill ~-23 ~12 ~-23 ~22 ~23 ~22 minecraft:air
# 六面白羊毛边界；顶/底各保留 48×48 面板底板。
fill ~-24 ~-1 ~-24 ~23 ~-1 ~23 minecraft:white_wool
fill ~-24 ~24 ~-24 ~23 ~24 ~23 minecraft:white_wool
fill ~-24 ~ ~-24 ~23 ~23 ~-24 minecraft:white_wool
fill ~-24 ~ ~23 ~23 ~23 ~23 minecraft:white_wool
fill ~-24 ~ ~-23 ~-24 ~23 ~22 minecraft:white_wool
fill ~23 ~ ~-23 ~23 ~23 ~22 minecraft:white_wool
# 与arena/start的签名校验一致，确认不会把其他方块区误当成挑战场。
setblock ~-6 ~-1 ~-6 minecraft:sea_lantern
setblock ~4 ~24 ~4 minecraft:sea_lantern
# 一层不可见光源照亮可刷怪地面，避免封闭房间自然生成敌对生物。
fill ~-23 ~6 ~-23 ~22 ~6 ~22 minecraft:light[level=15] replace air
# 施工完成后释放本次加载票据，并保留建场版本。
execute if data storage plm:arena build.tickets{c00:1b} run forceload remove ~-24 ~-24
execute if data storage plm:arena build.tickets{c01:1b} run forceload remove ~-24 ~-8
execute if data storage plm:arena build.tickets{c02:1b} run forceload remove ~-24 ~8
execute if data storage plm:arena build.tickets{c03:1b} run forceload remove ~-24 ~23
execute if data storage plm:arena build.tickets{c10:1b} run forceload remove ~-8 ~-24
execute if data storage plm:arena build.tickets{c11:1b} run forceload remove ~-8 ~-8
execute if data storage plm:arena build.tickets{c12:1b} run forceload remove ~-8 ~8
execute if data storage plm:arena build.tickets{c13:1b} run forceload remove ~-8 ~23
execute if data storage plm:arena build.tickets{c20:1b} run forceload remove ~8 ~-24
execute if data storage plm:arena build.tickets{c21:1b} run forceload remove ~8 ~-8
execute if data storage plm:arena build.tickets{c22:1b} run forceload remove ~8 ~8
execute if data storage plm:arena build.tickets{c23:1b} run forceload remove ~8 ~23
execute if data storage plm:arena build.tickets{c30:1b} run forceload remove ~23 ~-24
execute if data storage plm:arena build.tickets{c31:1b} run forceload remove ~23 ~-8
execute if data storage plm:arena build.tickets{c32:1b} run forceload remove ~23 ~8
execute if data storage plm:arena build.tickets{c33:1b} run forceload remove ~23 ~23
data modify storage plm:arena build set value {version:1b}
kill @e[type=minecraft:marker,tag=mirror_arena_build,distance=..0.1,limit=1]
