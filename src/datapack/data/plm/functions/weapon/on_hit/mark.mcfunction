# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# @s=被命中目标；#wp mirror_wtmp=攻击者 player_uid。
# 目标 uid 单调递增，用于「同一目标」判定（续影）；已设置过的目标不重复分配。
execute unless score @s mirror_uid matches 1.. run scoreboard players add #sys mirror_uid_next 1
execute unless score @s mirror_uid matches 1.. run scoreboard players operation @s mirror_uid = #sys mirror_uid_next
scoreboard players add @s mirror_xy_total 1
# 同一目标「由同一玩家连续命中」的计数：换玩家（或第一次记录）就清零重计。
# 镜熟(10 次)/镜痕(3 次) 读 mirror_xy_streak；mirror_xy_total 只保留总命中数（含其他玩家）。
execute unless score @s mirror_xy_owner = #wp mirror_wtmp run scoreboard players set @s mirror_xy_streak 0
scoreboard players operation @s mirror_xy_owner = #wp mirror_wtmp
scoreboard players add @s mirror_xy_streak 1
scoreboard players add @s mirror_hit_total 1
scoreboard players operation @s mirror_last_hit = #sys mirror_game_time
