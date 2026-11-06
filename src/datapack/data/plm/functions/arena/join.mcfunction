# 由入场流程对已确认的队友执行；最多招募 3 名队友，发起者由 arena/start 自动加入。
execute if score #arena mirror_arena_active matches 1 run tellraw @s {"text":"影主竞技场正在战斗，当前队伍已锁定。","color":"red"}
execute if score #arena mirror_arena_active matches 1 run return 0
execute unless entity @s[type=minecraft:player,tag=plm_shadow_active] run return 0
tag @s add mirror_arena_invited
tellraw @s {"text":"已登记影主挑战队伍；队长开启挑战时会一同入场。","color":"aqua"}
