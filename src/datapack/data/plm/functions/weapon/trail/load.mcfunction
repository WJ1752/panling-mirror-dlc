# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 6 个专用 marker（每个维度一套；先清掉旧的 plm_trail_*）
execute in minecraft:overworld run function plm:weapon/trail/load_dim
execute in minecraft:the_nether run function plm:weapon/trail/load_dim
execute in minecraft:the_end run function plm:weapon/trail/load_dim
