# Marker timers count down in seconds; the five ruin points add fixed landmark coverage.
execute in minecraft:overworld as @e[type=marker,tag=plm_shadow_wilderness_spawn] unless score @s shadow_spawn_cd matches 0.. run scoreboard players set @s shadow_spawn_cd 0
execute in minecraft:overworld as @e[type=marker,tag=plm_shadow_wilderness_spawn,scores={shadow_spawn_cd=1..}] run scoreboard players remove @s shadow_spawn_cd 1

# Unattended packs are removed; active wilderness players drive dynamic terrain spawns.
execute in minecraft:overworld as @e[tag=plm_shadow_wild] at @s unless entity @a[tag=plm_shadow_wilderness,distance=..64] run kill @s
scoreboard players set #shadow shadow_mob_count 0
execute in minecraft:overworld as @e[tag=plm_shadow_wild] run scoreboard players add #shadow shadow_mob_count 1

# Each ruin point spawns one three-mob pack on a 30-second cooldown, up to the shared cap.
execute in minecraft:overworld as @e[type=marker,tag=plm_shadow_wilderness_spawn] at @s if score @s shadow_spawn_cd matches 0 if entity @a[tag=plm_shadow_wilderness,distance=16..64] unless entity @e[tag=plm_shadow_wild,distance=..24] unless entity @e[type=marker,tag=plm_shadow_town_return,distance=..32] if score #shadow shadow_mob_count matches ..42 run function plm:shadow/spawn/pack

# Every active player can activate nearby terrain with a five-second personal cooldown.
execute in minecraft:overworld as @a[tag=plm_shadow_wilderness,tag=!plm_shadow_safe] unless score @s shadow_player_spawn_cd matches 0.. run scoreboard players set @s shadow_player_spawn_cd 0
execute in minecraft:overworld as @a[tag=plm_shadow_wilderness,tag=!plm_shadow_safe,scores={shadow_player_spawn_cd=1..}] run scoreboard players remove @s shadow_player_spawn_cd 1
execute in minecraft:overworld as @a[tag=plm_shadow_wilderness,tag=!plm_shadow_safe,scores={shadow_player_spawn_cd=0}] at @s if score #shadow shadow_mob_count matches ..42 run function plm:shadow/spawn/near_player
