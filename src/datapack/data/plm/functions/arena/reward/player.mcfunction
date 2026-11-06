execute unless score @s mirror_arena_run = #record mirror_arena_run run return 0
execute if score @s mirror_arena_paid = #record mirror_arena_run run return 0
execute if score @s mirror_shadow_lord_done matches ..0 run function plm:arena/reward/first
execute if score @s mirror_arena_paid = #record mirror_arena_run run return 0
function plm:arena/reward/repeat
scoreboard players operation @s mirror_arena_paid = #record mirror_arena_run
