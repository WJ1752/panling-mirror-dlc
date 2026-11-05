# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 1t 后统一处理被 inventory_changed 标记的玩家（schedule replace 会合并同一 tick 的多次变化）。
execute as @a[tag=mirror_refresh_pending] run function plm:weapon/refresh
tag @a[tag=mirror_refresh_pending] remove mirror_refresh_pending
