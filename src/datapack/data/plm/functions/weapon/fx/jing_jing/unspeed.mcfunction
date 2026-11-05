# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# @s=带 plm_trail_slow 的实体
attribute @s generic.movement_speed modifier remove 00000000-0000-0000-0000-0000000000a1
tag @s remove plm_trail_slow
scoreboard players set @s mirror_trail_slow_until 0
