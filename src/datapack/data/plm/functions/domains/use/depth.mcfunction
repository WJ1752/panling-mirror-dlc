advancement revoke @s only plm:domains/depth

scoreboard players add @s dm_depth 1
execute if score @s dm_depth matches 6.. run scoreboard players set @s dm_depth 1
tellraw @s [{"text":"所选镜深 "},{"score":{"name":"@s","objective":"dm_depth"}}]
