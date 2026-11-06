function plm:arena/load/defaults
scoreboard players add #arena mirror_arena_run 1
summon minecraft:marker ~ ~ ~ {Tags:["mirror_arena_anchor"]}
data modify storage plm:arena room set value {}
data modify storage plm:arena room.pos set from entity @e[type=minecraft:marker,tag=mirror_arena_anchor,distance=..0.1,limit=1] Pos
execute if dimension minecraft:overworld run data modify storage plm:arena room.dim set value "minecraft:overworld"
execute if dimension minecraft:the_nether run data modify storage plm:arena room.dim set value "minecraft:the_nether"
execute if dimension minecraft:the_end run data modify storage plm:arena room.dim set value "minecraft:the_end"
function plm:arena/room/keep_chunks
data modify storage plm:arena room.ready set value 1b
tag @a[tag=mirror_arena_member] remove mirror_arena_member
tag @a[tag=mirror_arena_inside] remove mirror_arena_inside
tag @s add mirror_arena_member
execute if score #arena mirror_portal_start matches 1 run tag @a[tag=mirror_arena_invited,tag=plm_shadow_active,tag=!mirror_arena_member,gamemode=!spectator,limit=3] add mirror_arena_member
execute unless score #arena mirror_portal_start matches 1 positioned ~-24 ~ ~-24 run tag @a[tag=mirror_arena_ready,tag=!mirror_arena_member,gamemode=!spectator,dx=47,dy=23,dz=47,sort=nearest,limit=3] add mirror_arena_member
tag @a[tag=mirror_arena_member] remove mirror_arena_ready
tag @a[tag=mirror_arena_invited] remove mirror_arena_invited
execute as @a[tag=mirror_arena_member] run function plm:arena/reward/recover
execute as @a[tag=mirror_arena_member] run scoreboard players operation @s mirror_arena_run = #arena mirror_arena_run
execute as @a[tag=mirror_arena_member] run scoreboard players add @s mirror_shadow_lord_done 0
execute as @a[tag=mirror_arena_member] run scoreboard players add @s mirror_arena_paid 0
scoreboard players set #arena mirror_arena_party 0
execute as @a[tag=mirror_arena_member] run scoreboard players add #arena mirror_arena_party 1
execute store result score #arena mirror_tmp run execute if entity @a[tag=mirror_arena_member]
execute if score #arena mirror_tmp matches 2 run scoreboard players set #boss mirror_boss_max 840
execute if score #arena mirror_tmp matches 3 run scoreboard players set #boss mirror_boss_max 1080
execute if score #arena mirror_tmp matches 4 run scoreboard players set #boss mirror_boss_max 1320
scoreboard players operation #boss mirror_boss_hp = #boss mirror_boss_max
execute store result bossbar plm:mirror_boss max run scoreboard players get #boss mirror_boss_max
scoreboard players set #arena mirror_boss_phase 1
# 把已锁定的参战名单送进战场，之后不再接纳新玩家。
tp @a[tag=mirror_arena_member] ~0.5 ~ ~0.5
execute as @a[tag=mirror_arena_member] run tag @s add plm_shadow_arena
function plm:arena/room/inside
function plm:arena/room/points
function plm:arena/panel/top
function plm:arena/panel/bottom
function plm:arena/boss/spawn
scoreboard players set #arena mirror_arena_active 1
function plm:arena/bossbar/restore
