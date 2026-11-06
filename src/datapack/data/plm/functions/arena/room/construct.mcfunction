# 在 plm_shadow_arena_center 的脚部中心一次性搭建 48×24×48 独立战场。
execute unless dimension minecraft:overworld run return 0
execute unless data storage plm:shadow {map_version:1b} run return 0
execute unless entity @e[type=minecraft:marker,tag=plm_shadow_arena_center,distance=..0.1,limit=1] run return 0
execute if score #arena mirror_arena_active matches 1 run return 0
execute if data storage plm:arena {build:{version:1b}} run return 0
execute if data storage plm:arena {build:{pending:1b}} run return 0
data modify storage plm:arena build set value {pending:1b}
# 预载完整16区块；只回收本次实际新加的强加载票据，不动影域长期票据。
data modify storage plm:arena build.tickets set value {}
execute store success storage plm:arena build.tickets.c00 byte 1 run forceload add ~-24 ~-24
execute store success storage plm:arena build.tickets.c01 byte 1 run forceload add ~-24 ~-8
execute store success storage plm:arena build.tickets.c02 byte 1 run forceload add ~-24 ~8
execute store success storage plm:arena build.tickets.c03 byte 1 run forceload add ~-24 ~23
execute store success storage plm:arena build.tickets.c10 byte 1 run forceload add ~-8 ~-24
execute store success storage plm:arena build.tickets.c11 byte 1 run forceload add ~-8 ~-8
execute store success storage plm:arena build.tickets.c12 byte 1 run forceload add ~-8 ~8
execute store success storage plm:arena build.tickets.c13 byte 1 run forceload add ~-8 ~23
execute store success storage plm:arena build.tickets.c20 byte 1 run forceload add ~8 ~-24
execute store success storage plm:arena build.tickets.c21 byte 1 run forceload add ~8 ~-8
execute store success storage plm:arena build.tickets.c22 byte 1 run forceload add ~8 ~8
execute store success storage plm:arena build.tickets.c23 byte 1 run forceload add ~8 ~23
execute store success storage plm:arena build.tickets.c30 byte 1 run forceload add ~23 ~-24
execute store success storage plm:arena build.tickets.c31 byte 1 run forceload add ~23 ~-8
execute store success storage plm:arena build.tickets.c32 byte 1 run forceload add ~23 ~8
execute store success storage plm:arena build.tickets.c33 byte 1 run forceload add ~23 ~23
summon minecraft:marker ~ ~ ~ {Tags:["mirror_arena_build"]}
schedule function plm:arena/room/construct_resume 1t replace
