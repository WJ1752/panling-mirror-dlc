# 镜痕留痕：@s=玩家；目标已打 plm_ctx_target。
# 对同一目标由同一玩家累计命中 >=3 后留痕 5s（100t）；mirror_xy_streak 由 on_hit/mark 维护。
execute unless score @s wp_affix_fx_jing_hen matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_xy_streak matches 3.. run return 0
scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_jinghen_until = #sys mirror_game_time
scoreboard players add @e[tag=plm_ctx_target,limit=1] mirror_jinghen_until 100
scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_jinghen_owner = @s player_uid
execute as @e[tag=plm_ctx_target,limit=1] at @s run particle minecraft:dust 0.55 0.85 1 1 ~ ~1 ~ 0.3 0.4 0.3 0.02 8
