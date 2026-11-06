execute store result score #record mirror_arena_run run data get storage plm:arena scan[0].run
execute store result score #pending mirror_arena_party run data get storage plm:arena scan[0].pending
scoreboard players set #claim mirror_arena_party 0
execute if score @s mirror_arena_run = #record mirror_arena_run unless score @s mirror_arena_paid = #record mirror_arena_run if score #pending mirror_arena_party matches 1.. run scoreboard players set #claim mirror_arena_party 1
execute if score #claim mirror_arena_party matches 1 run scoreboard players remove #pending mirror_arena_party 1
execute store result storage plm:arena scan[0].pending int 1 run scoreboard players get #pending mirror_arena_party
execute if score #claim mirror_arena_party matches 1 run function plm:arena/reward/player
execute if score #pending mirror_arena_party matches 1.. run data modify storage plm:arena scanned append from storage plm:arena scan[0]
data remove storage plm:arena scan[0]
execute if data storage plm:arena scan[0] run function plm:arena/reward/recover_one
