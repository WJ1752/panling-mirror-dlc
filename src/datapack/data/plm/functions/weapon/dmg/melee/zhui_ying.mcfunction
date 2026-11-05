# 追映（zhui_ying）— target
# 目标有 slowness / vertigo_5ticks（眩晕）/ 被你留了镜痕时 +12%
execute unless score @s wp_affix_dmg_zhui_ying matches 1.. run return 0
scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 0
execute as @e[tag=plm_ctx_target,limit=1] if predicate pld:effect_check/slowness run scoreboard players set @s mirror_ctx_hit 1
# 本体 sword3 的眩晕状态：vertigo_5ticks（warrior_attack/load.mcfunction:3 声明）。
execute if entity @e[tag=plm_ctx_target,limit=1,scores={vertigo_5ticks=1..}] run scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 1
# 共鸣（镜痕 + 追映）：镜痕目标视为「被标记」，追映对其始终生效
execute if score @s wp_affix_fx_jing_hen matches 1.. if score @e[tag=plm_ctx_target,limit=1] mirror_jinghen_until >= #sys mirror_game_time if score @e[tag=plm_ctx_target,limit=1] mirror_jinghen_owner = @s player_uid run scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 1
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit matches 1 run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_zhui_ying
