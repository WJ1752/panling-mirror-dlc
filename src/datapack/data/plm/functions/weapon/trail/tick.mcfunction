# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 每 5t：对三个原版维度分别处理（marker/slow 都只存在于各自维度）。
execute in minecraft:overworld run function plm:weapon/trail/tick_dim
execute in minecraft:the_nether run function plm:weapon/trail/tick_dim
execute in minecraft:the_end run function plm:weapon/trail/tick_dim
