# 借影快照：@s=玩家；目标已打 plm_ctx_target（目标仍存活时调用）。
# player_killed_entity 拿不到死者，所以必须在命中时把「1 个增益」记到玩家身上。
execute unless score @s wp_affix_fx_jie_ying matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
scoreboard players set @s mirror_jieying_id 0
execute if data entity @e[tag=plm_ctx_target,limit=1] ActiveEffects[0] store result score @s mirror_jieying_id run data get entity @e[tag=plm_ctx_target,limit=1] ActiveEffects[0].Id
execute if score @s mirror_jieying_id matches 1.. run scoreboard players operation @s mirror_jieying_until = #sys mirror_game_time
execute if score @s mirror_jieying_id matches 1.. run scoreboard players add @s mirror_jieying_until 100
