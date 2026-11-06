# NPC/返程锚需要等主城chunk完成forceload后再创建。
function plm:shadow/main/setup

# 签名位和map_version阻止在真实Overworld地形未安装时生成影域建筑逻辑。
execute in minecraft:overworld if block -704 -63 -1450 minecraft:bedrock unless data storage plm:shadow {map_version:1b} run function plm:shadow/map/setup
execute in minecraft:overworld if block -704 -63 -1450 minecraft:bedrock if score #shadow shadow_clock matches 0 run function plm:shadow/build
execute if data storage plm:shadow {map_version:1b} run function plm:shadow/town/markers
execute if data storage plm:shadow {map_version:1b} run function plm:shadow/town/setup
execute if data storage plm:shadow {map_version:1b} run function plm:shadow/hub/merchant_spawn

# 地下竞技场marker就绪后调用一次；等待构建函数写入完成签名再标记成功。
execute in minecraft:overworld positioned as @e[type=marker,tag=plm_shadow_arena_center,limit=1] if score #shadow shadow_arena_built matches 0 run function plm:arena/room/construct
execute if data storage plm:arena {build:{version:1b}} if score #shadow shadow_arena_built matches 0 run scoreboard players set #shadow shadow_arena_built 1

# 掉线重登后回影域城镇，保留付费活动资格；死亡只在重生后回城一次。
execute as @a[tag=plm_shadow_active] unless score @s shadow_leave_seen matches 0.. run scoreboard players set @s shadow_leave_seen 0
execute as @a[tag=plm_shadow_active] if score @s mirror_leave > @s shadow_leave_seen run function plm:shadow/leave/rejoin
execute as @a[tag=plm_shadow_active,nbt=!{Health:0.0f}] if score @s shadow_died > @s shadow_died_seen run function plm:shadow/leave/death
execute as @a[tag=plm_shadow_active,nbt=!{Health:0.0f}] run scoreboard players operation @s shadow_died_seen = @s shadow_died

# 镇区按map manifest整盒清除hostile并提供抗伤；地下竞技场在Y=-52..-16。
execute in minecraft:overworld run kill @e[type=#plm:shadow_hostile,x=-724,y=195,z=-1474,dx=38,dy=29,dz=39,tag=!mirror_arena_boss,tag=!mirror_arena_mob,tag=!mirror_summon]
execute as @a[tag=plm_shadow_active,x=-724,y=195,z=-1474,dx=38,dy=29,dz=39] run tag @s add plm_shadow_safe
execute as @a[tag=plm_shadow_active,tag=plm_shadow_safe] unless entity @s[x=-724,y=195,z=-1474,dx=38,dy=29,dz=39] run tag @s remove plm_shadow_safe
execute as @a[tag=plm_shadow_safe,tag=mirror_arena_inside] run tag @s remove plm_shadow_safe
execute as @a[tag=plm_shadow_safe,tag=!mirror_arena_inside] run effect give @s minecraft:resistance 3 4 true

# 镜像地图内hostile可以成为影域enemy；玩家拾影只在已付费wilderness有效。
execute in minecraft:overworld as @e[type=#plm:shadow_hostile,x=-893,y=-64,z=-1669,dx=367,dy=383,dz=392,tag=!monster] run tag @s add monster
execute as @a[tag=plm_shadow_active,x=-893,y=0,z=-1669,dx=367,dy=319,dz=392] run tag @s add plm_shadow_wilderness
execute as @a[tag=plm_shadow_active,tag=plm_shadow_wilderness] unless entity @s[x=-893,y=0,z=-1669,dx=367,dy=319,dz=392] run tag @s remove plm_shadow_wilderness

# 每秒重试影主离线奖励和marker/附近刷怪，实体上限由spawn/tick共用计数控制。
scoreboard players add #shadow shadow_clock 1
execute if score #shadow shadow_clock matches 20.. run scoreboard players set #shadow shadow_clock 0
execute if score #shadow shadow_clock matches 0 as @a[tag=plm_shadow_active] run function plm:arena/reward/recover
execute if score #shadow shadow_clock matches 0 as @a run clear @s minecraft:paper{plm_shadow_pass:"dust"}
execute if score #shadow shadow_clock matches 0 as @a run clear @s minecraft:paper{plm_shadow_pass:"silver"}
execute if score #shadow shadow_clock matches 0 run function plm:shadow/spawn/tick

# 未付费玩家不能跨边界步入；active玩家离开Overworld地图范围即回主城并结束会话。
execute in minecraft:overworld as @a[tag=!plm_shadow_active,x=-893,y=-64,z=-1669,dx=367,dy=383,dz=392] unless entity @s[gamemode=creative] unless entity @s[gamemode=spectator] run function plm:shadow/guard/unauthorized
execute as @a[tag=plm_shadow_active] at @s unless dimension minecraft:overworld run function plm:shadow/guard/out_of_bounds
execute as @a[tag=plm_shadow_active] at @s if dimension minecraft:overworld unless entity @s[x=-893,y=-64,z=-1669,dx=367,dy=383,dz=392] run function plm:shadow/guard/out_of_bounds
