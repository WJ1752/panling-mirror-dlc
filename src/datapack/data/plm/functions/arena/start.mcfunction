# 调用：execute as <发起玩家> positioned <场地中心脚部 XYZ> run function plm:arena/start
# 其他队员在场内打 mirror_arena_ready；只支持同一时间一个 1～4 人竞技场。
execute if score #arena mirror_arena_active matches 1 run return 0
execute unless entity @s[type=minecraft:player,gamemode=!spectator] run return 0
execute align xyz positioned ~-24 ~ ~-24 unless entity @s[dx=47,dy=23,dz=47] run return 0
# 与本体技能一致，正式支持三个原版维度；须能在无人时按所存维度重新定位。
execute unless dimension minecraft:overworld unless dimension minecraft:the_nether unless dimension minecraft:the_end run return 0
execute align xyz run function plm:arena/room/visible
execute if score #arena mirror_tmp matches 0 run return 0
# 灰盒上下两层海晶灯描边作为场地签名，防止在普通地形误启动并改方块。
execute align xyz unless block ~-6 ~-1 ~-6 minecraft:sea_lantern run return 0
execute align xyz unless block ~4 ~24 ~4 minecraft:sea_lantern run return 0
# 终局占用一种方块状态；有同状态装饰的地图拒绝开战，保留原地板。
scoreboard players set #arena mirror_tmp 0
scoreboard players set #arena mirror_poison_i 0
execute align xyz positioned ~-23 ~-1 ~-23 run function plm:arena/poison/check_row
execute if score #arena mirror_tmp matches 1 run tellraw @s {"text":"竞技场地板含有终局专用毒格，请检查场地。","color":"red"}
execute if score #arena mirror_tmp matches 1 run return 0
execute align xyz run function plm:arena/start_room
