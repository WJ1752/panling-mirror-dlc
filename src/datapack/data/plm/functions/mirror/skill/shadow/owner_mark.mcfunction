# @s = 倒影；把同维度、uid 匹配的主人打上 mirror_shadow_owner_ref
# 倒影的 mirror_shadow_dim 在召唤时写入；owner 在不同维度时不会误匹配。
scoreboard players operation #shadow_owner mirror_skill_tmp = @s mirror_shadow_owner
scoreboard players operation #shadow_dim mirror_skill_tmp2 = @s mirror_shadow_dim
tag @a remove mirror_shadow_owner_ref
execute if score #shadow_dim mirror_skill_tmp2 matches 0 as @a at @s if dimension minecraft:overworld if score @s player_uid = #shadow_owner mirror_skill_tmp run tag @s add mirror_shadow_owner_ref
execute if score #shadow_dim mirror_skill_tmp2 matches 1 as @a at @s if dimension minecraft:the_nether if score @s player_uid = #shadow_owner mirror_skill_tmp run tag @s add mirror_shadow_owner_ref
execute if score #shadow_dim mirror_skill_tmp2 matches 2 as @a at @s if dimension minecraft:the_end if score @s player_uid = #shadow_owner mirror_skill_tmp run tag @s add mirror_shadow_owner_ref
