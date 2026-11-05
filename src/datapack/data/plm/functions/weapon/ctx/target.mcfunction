# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 目标选择 API：warrior_tag 优先；否则 5 格内最近 tag=monster，再否则 tag=mirror_boss，
# 最后 tag=mirror_summon。结果写在实体 tag plm_ctx_target 上。
# ctx/melee、on_hit、target_hp、target_behind 都消费它。
# 正常怪物命中由本体 warrior_tag 命中；镜主/召唤物没有 warrior_tag，走后面 fallback。
tag @e[tag=plm_ctx_target] remove plm_ctx_target
execute if entity @e[tag=warrior_tag,limit=1] run tag @e[tag=warrior_tag,limit=1] add plm_ctx_target
execute unless entity @e[tag=plm_ctx_target] at @s run tag @e[tag=monster,distance=..5,sort=nearest,limit=1] add plm_ctx_target
execute unless entity @e[tag=plm_ctx_target] at @s run tag @e[tag=mirror_boss,distance=..5,sort=nearest,limit=1] add plm_ctx_target
execute unless entity @e[tag=plm_ctx_target] at @s run tag @e[tag=mirror_summon,distance=..5,sort=nearest,limit=1] add plm_ctx_target
