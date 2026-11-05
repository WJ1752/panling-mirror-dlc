# @s=影伤 marker：主人不在/无目标 → 丢弃并归还队列计数
scoreboard players operation #ch_owner mirror_skill_tmp = @s mirror_shadow_hit_owner
execute as @a if score @s player_uid = #ch_owner mirror_skill_tmp run scoreboard players remove @s mirror_ch_queue 1
execute as @a if score @s player_uid = #ch_owner mirror_skill_tmp if score @s mirror_ch_queue matches ..-1 run scoreboard players set @s mirror_ch_queue 0
kill @s
