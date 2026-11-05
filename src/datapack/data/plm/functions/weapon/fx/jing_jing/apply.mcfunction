# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# @s=trail marker。只对 tag=monster / tag=mirror_boss 的实体生效。
execute as @e[tag=monster,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow
execute as @e[tag=mirror_boss,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow
