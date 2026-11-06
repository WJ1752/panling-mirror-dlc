# @s为玩家。离开影域后回到主城Overworld；只有成功传送才清理影域会话。
function plm:shadow/main_return
execute if score @s shadow_tp matches 1 if entity @s[tag=mirror_arena_member] if score @s mirror_arena_run = #arena mirror_arena_run if score #arena mirror_arena_active matches 1 run scoreboard players remove #arena mirror_arena_party 1
execute if score @s shadow_tp matches 1 if entity @s[tag=mirror_arena_member] if score @s mirror_arena_run = #arena mirror_arena_run if score #arena mirror_arena_active matches 1 run scoreboard players set @s mirror_arena_run 0
execute if score @s shadow_tp matches 1 run tag @s remove plm_shadow_active
execute if score @s shadow_tp matches 1 run tag @s remove plm_shadow_safe
execute if score @s shadow_tp matches 1 run tag @s remove plm_shadow_wilderness
execute if score @s shadow_tp matches 1 run tag @s remove plm_shadow_arena
execute if score @s shadow_tp matches 1 run tag @s remove mirror_arena_member
execute if score @s shadow_tp matches 1 run tag @s remove mirror_arena_inside
execute if score @s shadow_tp matches 1 run tag @s remove mirror_arena_ready
execute if score @s shadow_tp matches 1 run tag @s remove mirror_arena_invited
tellraw @s[scores={shadow_tp=0}] {"text":"主城回程点暂不可用，请稍后重试。","color":"yellow"}
