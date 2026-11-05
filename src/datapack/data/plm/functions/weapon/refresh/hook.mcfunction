# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 plm:weapon/inventory_changed 进度 reward：镜武进入/离开/改写了玩家背包时标记重解析。
# 不在这里直接 refresh：inventory_changed 可能在磨镜台 item replace 命令内部同步触发，
# 此时 storage plm:weapon 正被台子流程使用；延迟 1t 到 pending 里处理，避免重入覆盖。
advancement revoke @s only plm:weapon/inventory_changed
tag @s add mirror_refresh_pending
schedule function plm:weapon/refresh/pending 1t replace
