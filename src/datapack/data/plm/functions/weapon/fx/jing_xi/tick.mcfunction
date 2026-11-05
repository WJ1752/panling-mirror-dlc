# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 镜息：脱战 3s 后开 100t（5s）窗口，每 20t 回复一次，共 5 次；每次 0.5%×val/100 最大生命。
# 用 mirror_fx_jing_xi_next 逐次推进，保证窗口内恰好 5 次，而不是只回一次。
execute unless score @s wp_affix_fx_jing_xi matches 1.. run return 0
# 新玩家/旧存档可能从未受伤，三个分数未设置；未设置时 if score 永远失败，镜息不会启动。
execute unless score @s mirror_last_combat matches -2147483648.. run scoreboard players operation @s mirror_last_combat = #sys mirror_game_time
execute unless score @s mirror_fx_jing_xi_until matches -2147483648.. run scoreboard players set @s mirror_fx_jing_xi_until 0
execute unless score @s mirror_fx_jing_xi_done matches -2147483648.. run scoreboard players set @s mirror_fx_jing_xi_done 0
execute unless score @s mirror_fx_jing_xi_next matches -2147483648.. run scoreboard players set @s mirror_fx_jing_xi_next 0
scoreboard players operation #wp mirror_wtmp = #sys mirror_game_time
scoreboard players operation #wp mirror_wtmp -= @s mirror_last_combat
execute if score #wp mirror_wtmp matches ..59 run scoreboard players set @s mirror_fx_jing_xi_until 0
execute if score #wp mirror_wtmp matches ..59 run scoreboard players set @s mirror_fx_jing_xi_done 0
execute if score #wp mirror_wtmp matches ..59 run scoreboard players set @s mirror_fx_jing_xi_next 0

# 开窗：用 #wp mirror_wtmp2 作一次性标志，避免先写 until 后条件立刻失效。
scoreboard players set #wp mirror_wtmp2 0
execute if score #wp mirror_wtmp matches 60.. if score @s mirror_fx_jing_xi_done matches 0 if score @s mirror_fx_jing_xi_until matches 0 run scoreboard players set #wp mirror_wtmp2 1
execute if score #wp mirror_wtmp2 matches 1 run scoreboard players operation @s mirror_fx_jing_xi_until = #sys mirror_game_time
execute if score #wp mirror_wtmp2 matches 1 run scoreboard players add @s mirror_fx_jing_xi_until 100
execute if score #wp mirror_wtmp2 matches 1 run scoreboard players operation @s mirror_fx_jing_xi_next = #sys mirror_game_time

# 窗口内每 20t 回复一次；5 次后 next > until，自然停止。
execute if score @s mirror_fx_jing_xi_until matches 1.. if score #sys mirror_game_time < @s mirror_fx_jing_xi_until if score #sys mirror_game_time >= @s mirror_fx_jing_xi_next run function plm:weapon/fx/jing_xi/heal
execute if score @s mirror_fx_jing_xi_until matches 1.. if score #sys mirror_game_time < @s mirror_fx_jing_xi_until if score #sys mirror_game_time >= @s mirror_fx_jing_xi_next run scoreboard players add @s mirror_fx_jing_xi_next 20
execute if score @s mirror_fx_jing_xi_until matches 1.. if score #sys mirror_game_time >= @s mirror_fx_jing_xi_until run scoreboard players set @s mirror_fx_jing_xi_until 0
execute if score @s mirror_fx_jing_xi_until matches 0 if score @s mirror_fx_jing_xi_done matches 0 if score #wp mirror_wtmp matches 60.. run scoreboard players set @s mirror_fx_jing_xi_done 1
