# @s为玩家。重登后统一回城，清除掉线/死亡期间遗留的待入场计数。
function plm:shadow/town_return
function plm:arena/reward/recover
tag @s remove mirror_arena_member
tag @s remove mirror_arena_inside
tag @s remove mirror_arena_ready
tag @s remove mirror_arena_invited
tag @s remove plm_shadow_arena
execute if score @s shadow_tp matches 1 run scoreboard players operation @s shadow_leave_seen = @s mirror_leave
execute if score @s shadow_tp matches 1 run scoreboard players operation @s shadow_died_seen = @s shadow_died
execute if score @s shadow_tp matches 1 run tellraw @s {"text":"影域之行已恢复，你已回到城镇。","color":"yellow"}
