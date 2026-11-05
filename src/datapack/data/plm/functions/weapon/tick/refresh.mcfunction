# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 每 5t 检查当前生效槽位；丢出最后一把镜武/切到非镜武/act:0 都会在 5t 内 clear。
# 全量 parse 仍只在 activation / inventory_changed / 槽位变化时发生。
execute as @a[tag=mirror_weapon_active] run function plm:weapon/refresh/check
