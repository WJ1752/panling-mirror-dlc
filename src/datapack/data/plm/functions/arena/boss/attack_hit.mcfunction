scoreboard players set #arena mirror_attack_cd 24
particle minecraft:sweep_attack ~ ~1 ~ 0 0 0 0 1
playsound minecraft:entity.player.attack.sweep master @a[tag=mirror_arena_inside,distance=..12] ~ ~ ~ 0.7 0.8
execute as @a[tag=mirror_arena_inside,distance=..2.8,sort=nearest,limit=1] run damage @s 4 minecraft:mob_attack by @e[tag=mirror_arena_boss,limit=1]
