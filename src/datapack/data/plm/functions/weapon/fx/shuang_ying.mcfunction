# 双影（shuang_ying）— 伤害侧：每 8s，本次攻击追加一次 10% 伤害的幻影攻击。
# 冷却写在 mirror_fx_shuang_ying_cd（game_time 时间戳，近战/弓弩共用一个 8s 计时）。
# 10 个百分点 = mirror_ctx_extra 的 100（与追加伤害同单位）。
execute unless score @s wp_affix_fx_shuang_ying matches 1.. run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score @s mirror_fx_shuang_ying_cd matches -2147483648.. run scoreboard players set @s mirror_fx_shuang_ying_cd 0
execute if score @s mirror_fx_shuang_ying_cd > #sys mirror_game_time run return 0
scoreboard players operation @s mirror_fx_shuang_ying_cd = #sys mirror_game_time
scoreboard players add @s mirror_fx_shuang_ying_cd 160
scoreboard players add @s mirror_ctx_extra 100
execute as @e[tag=plm_ctx_target,limit=1] at @s run particle minecraft:dust 0.8 0.8 1 1 ~ ~1 ~ 0.3 0.4 0.3 0.02 10
# 共鸣（双影 + 连星）：幻影攻击计入连星的第 3 次计数（推进 mirror_hit_seq，供下一击读取）
execute if score @s wp_affix_dmg_lian_xing matches 1.. run scoreboard players add @s mirror_hit_seq 1
execute if score @s mirror_hit_seq matches 3.. run scoreboard players set @s mirror_hit_seq 0
