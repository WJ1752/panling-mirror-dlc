# 本场只在 Boss 虚拟生命归零后进入；在线成员即时邮件，掉线成员保留按局号领取的收据。
scoreboard players operation #record mirror_arena_run = #arena mirror_arena_run
execute as @a[tag=mirror_arena_member] run function plm:arena/reward/player
scoreboard players set #online mirror_arena_party 0
execute as @a[tag=mirror_arena_member] if score @s mirror_arena_run = #record mirror_arena_run run scoreboard players add #online mirror_arena_party 1
scoreboard players operation #pending mirror_arena_party = #arena mirror_arena_party
scoreboard players operation #pending mirror_arena_party -= #online mirror_arena_party
execute if score #pending mirror_arena_party matches 1.. run data modify storage plm:arena receipt set value {}
execute if score #pending mirror_arena_party matches 1.. store result storage plm:arena receipt.run int 1 run scoreboard players get #arena mirror_arena_run
execute if score #pending mirror_arena_party matches 1.. store result storage plm:arena receipt.pending int 1 run scoreboard players get #pending mirror_arena_party
execute if score #pending mirror_arena_party matches 1.. run data modify storage plm:arena receipts append from storage plm:arena receipt
execute if score #pending mirror_arena_party matches 1.. run tellraw @a[tag=mirror_arena_inside] {"text":"离线队员的首领奖励已保留，重返影域时会寄送。","color":"yellow"}
