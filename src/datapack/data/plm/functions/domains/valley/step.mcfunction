scoreboard players add @s dm_age 1
execute if score @s dm_age matches 36000.. run function plm:domains/valley/abort
execute unless score #valley dm_state matches 2 run return 0
execute as @a[tag=plm_d_valley,scores={dm_died=1..}] run scoreboard players add #valley dm_deaths 1
execute as @a[tag=plm_d_valley,scores={dm_died=1..}] run scoreboard players set @s dm_dead 1
scoreboard players set @a[tag=plm_d_valley] dm_died 0
execute unless entity @a[tag=plm_d_valley,scores={dm_dead=0}] run function plm:domains/valley/abort
execute unless score #valley dm_state matches 2 run return 0
execute as @a[tag=plm_d_valley] if score @s mirror_leave > @s dm_leave run tag @s add plm_rescue
execute as @a[tag=plm_d_valley] run scoreboard players operation @s dm_leave = @s mirror_leave
execute as @a[tag=plm_d_valley] at @s unless dimension plm:domains run tag @s add plm_rescue
execute as @a[tag=plm_d_valley] unless entity @s[tag=plm_rescue] unless entity @s[x=1024,y=58,z=-2,dx=96,dy=34,dz=35] unless data entity @s {Health:0.0f} run damage @s 2 minecraft:fall
execute as @a[tag=plm_d_valley] unless entity @s[x=1024,y=58,z=-2,dx=96,dy=34,dz=35] run tag @s add plm_rescue
tag @a[tag=plm_d_valley,scores={dm_dead=1},nbt=!{Health:0.0f}] add plm_rescue
tag @a[tag=plm_d_valley,nbt={Health:0.0f}] remove plm_rescue
execute if entity @a[tag=plm_d_valley,tag=plm_rescue] run function plm:domains/valley/checkpoint
scoreboard players set @a[tag=plm_d_valley,tag=plm_rescue] dm_dead 0
tag @a[tag=plm_d_valley] remove plm_rescue
function plm:domains/valley/tick
