# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# -8% movement_speed，2s 后由 trail/tick 清理。固定用 max 8%（val 只作为开关）。
tag @s add plm_trail_slow
scoreboard players operation @s mirror_trail_slow_until = #sys mirror_game_time
scoreboard players add @s mirror_trail_slow_until 40
attribute @s generic.movement_speed modifier add 00000000-0000-0000-0000-0000000000a1 "plm_trail_slow" -0.08 multiply
