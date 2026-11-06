advancement revoke @s only plm:shadow/arena_start
execute unless entity @s[tag=plm_shadow_active] run tellraw @s {"text":"须先通过主城入口NPC进入影域，才能开启影主挑战。","color":"yellow"}
execute unless entity @s[tag=plm_shadow_active] run return 0
execute unless dimension minecraft:overworld run return 0
execute unless entity @e[type=marker,tag=plm_shadow_arena_portal_point,distance=..6,limit=1] run return 0
execute in minecraft:overworld positioned as @e[type=marker,tag=plm_shadow_arena_center,limit=1] run function plm:arena/portal_start
