scoreboard players add @s dm_age 1
execute if score @s dm_age matches 36000.. run function plm:domains/fire/abort
execute unless score #fire dm_state matches 2 run return 0
execute as @a[tag=plm_d_fire,scores={dm_died=1..}] run scoreboard players add #fire dm_deaths 1
execute as @a[tag=plm_d_fire,scores={dm_died=1..}] run scoreboard players set @s dm_dead 1
scoreboard players set @a[tag=plm_d_fire] dm_died 0
execute unless entity @a[tag=plm_d_fire,scores={dm_dead=0}] run function plm:domains/fire/abort
execute unless score #fire dm_state matches 2 run return 0
execute as @a[tag=plm_d_fire] if score @s mirror_leave > @s dm_leave run tag @s add plm_rescue
execute as @a[tag=plm_d_fire] run scoreboard players operation @s dm_leave = @s mirror_leave
execute as @a[tag=plm_d_fire] at @s unless dimension plm:domains run tag @s add plm_rescue
execute as @a[tag=plm_d_fire] unless entity @s[tag=plm_rescue] unless entity @s[x=256,y=58,z=-2,dx=96,dy=34,dz=35] unless data entity @s {Health:0.0f} run damage @s 2 minecraft:fall
execute as @a[tag=plm_d_fire] unless entity @s[x=256,y=58,z=-2,dx=96,dy=34,dz=35] run tag @s add plm_rescue
tag @a[tag=plm_d_fire,scores={dm_dead=1},nbt=!{Health:0.0f}] add plm_rescue
tag @a[tag=plm_d_fire,nbt={Health:0.0f}] remove plm_rescue
execute if entity @a[tag=plm_d_fire,tag=plm_rescue] run function plm:domains/fire/checkpoint
scoreboard players set @a[tag=plm_d_fire,tag=plm_rescue] dm_dead 0
tag @a[tag=plm_d_fire] remove plm_rescue
function plm:domains/fire/tick
