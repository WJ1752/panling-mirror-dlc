# 照隙（zhao_xi）— 伤害侧：把「下一次受伤 +5%」结算进本次追加伤害，并清掉待结算标记。
# 标记由 plm:weapon/fx/zhao_xi/proc 在命中后写入；双照共鸣在 DMG 分支里先读这个标记，再走到这里消费。
execute unless score @s wp_affix_fx_zhao_xi matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_ready matches 1 run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_until >= #sys mirror_game_time run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_owner = @s player_uid run return 0
# 5 个百分点 = mirror_ctx_extra 的 50
scoreboard players add @s mirror_ctx_extra 50
scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_ready 0
