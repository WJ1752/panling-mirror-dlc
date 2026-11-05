# 重新核对攻击者本人所在维度、场地和局号。用 @a 的房间选择器约束维度。
tag @s remove mirror_arena_inside
tag @s add mirror_arena_hit_actor
execute at @e[tag=mirror_arena_anchor,limit=1] positioned ~-24 ~ ~-24 as @a[tag=mirror_arena_hit_actor,tag=mirror_arena_member,gamemode=!spectator,dx=47,dy=23,dz=47,limit=1] if score @s mirror_arena_run = #arena mirror_arena_run run tag @s add mirror_arena_inside
tag @s remove mirror_arena_hit_actor
