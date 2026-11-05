# 重新计算本维度的实时参战范围；旧局断线留下的标签由局号隔离。
tag @a[tag=mirror_arena_inside] remove mirror_arena_inside
execute positioned ~-24 ~ ~-24 as @a[tag=mirror_arena_member,gamemode=!spectator,nbt=!{Health:0.0f},dx=47,dy=23,dz=47] if score @s mirror_arena_run = #arena mirror_arena_run at @s align xyz positioned ~-23.5 ~-23.5 ~-23.5 if entity @e[type=minecraft:marker,tag=mirror_arena_anchor,dx=47,dy=23,dz=47] run tag @s add mirror_arena_inside
bossbar set plm:mirror_boss players @a[tag=mirror_arena_inside,distance=0..]
