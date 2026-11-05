# 照隙标记：@s=玩家；目标已打 plm_ctx_target。
# 攻击概率使目标发光 3s，并留下「下一次受伤 +5%」（mirror_zhaoxi_ready + 归属/到期）。
execute unless score @s wp_affix_fx_zhao_xi matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute if score @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_ready matches 1 run return 0
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_fx_zhao_xi
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
function plm:weapon/util/rand100
execute if score #t wp_rand > #wp mirror_wtmp run return 0
effect give @e[tag=plm_ctx_target,limit=1] minecraft:glowing 3 0 true
scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_until = #sys mirror_game_time
scoreboard players add @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_until 60
scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_ready 1
scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_owner = @s player_uid
