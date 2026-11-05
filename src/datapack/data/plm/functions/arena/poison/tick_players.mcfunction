# 只有脚下处于本场地板平面并站在本场毒格的参战者每秒承受 1 HP。
execute positioned ~-23 ~ ~-23 as @a[tag=mirror_arena_inside,dx=45,dy=0,dz=45] at @s align xyz if block ~ ~-1 ~ minecraft:green_glazed_terracotta[facing=west] positioned ~-22.5 ~-0.5 ~-22.5 if entity @e[type=minecraft:marker,tag=mirror_arena_anchor,dx=45,dy=0,dz=45] run damage @s 1 minecraft:magic
