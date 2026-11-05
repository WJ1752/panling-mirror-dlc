# 重影队列上限（每玩家 32）：@s=玩家
scoreboard players operation #ch_owner mirror_skill_tmp = @s player_uid
tag @e[tag=mirror_shadow_hit] remove mirror_ch_mine
execute as @e[tag=mirror_shadow_hit] if score @s mirror_shadow_hit_owner = #ch_owner mirror_skill_tmp run tag @s add mirror_ch_mine
kill @e[tag=mirror_ch_mine,limit=1]
tag @e[tag=mirror_ch_mine] remove mirror_ch_mine
scoreboard players set @s mirror_ch_queue 32
