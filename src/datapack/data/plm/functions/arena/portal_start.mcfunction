# 正式传送入口：队友先由 arena/join 标记，发起者在传送点启动本函数。
# 调用：execute positioned <plm_shadow_arena_center XYZ> as <发起玩家> run function plm:arena/portal_start
execute unless entity @s[type=minecraft:player,tag=plm_shadow_active] run tellraw @s {"text":"你需要先进入影域，才能挑战影主。","color":"red"}
execute unless entity @s[type=minecraft:player,tag=plm_shadow_active] run return 0
scoreboard players set #arena mirror_portal_start 1
function plm:arena/start
scoreboard players set #arena mirror_portal_start 0
