# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 镜径：每 4 格（walk_one_cm >=400）留一个 2s 镜影；用 marker 承载位置（1.20.1 无 macro，storage 不能直接喂 positioned）。
execute unless score @s wp_affix_fx_jing_jing matches 1.. run scoreboard players set @s mirror_walk_last 0
execute unless score @s wp_affix_fx_jing_jing matches 1.. run return 0
scoreboard players set #wp mirror_wtmp 0
scoreboard players set #wp mirror_wtmp2 0
execute store result score #wp mirror_wtmp run scoreboard players get @s mirror_walk_stat
scoreboard players operation #wp mirror_wtmp2 = #wp mirror_wtmp
scoreboard players operation #wp mirror_wtmp -= @s mirror_walk_last
scoreboard players operation @s mirror_walk_last = #wp mirror_wtmp2
execute unless score #wp mirror_wtmp matches 400.. run return 0
execute at @s run function plm:weapon/fx/jing_jing/point
execute at @s run function plm:weapon/trail/tick_dim
execute at @s as @e[tag=monster,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow
execute at @s as @e[tag=mirror_boss,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow
execute as @e[tag=plm_trail_slow,distance=..30000000] if score @s mirror_trail_slow_until <= #sys mirror_game_time run function plm:weapon/fx/jing_jing/unspeed
