# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 真正追加一次伤害。mirror_affix_damage 防止本系统再次进入 on-hit；
# 本体 when_cause_damage 的套装函数自带 armor_set_bonus_cool_4_tick 冷却（metal/40、fire/40 内设置），
# 同一 tick 的第二次调用会被冷却拦截；advancement 本身仍会再跑一次（零覆盖约束下无法屏蔽，见 notes）。
tag @s add if_death_count
tag @s add mirror_affix_damage
tag @e[tag=plm_ctx_target,limit=1] add mirror_affix_damage
execute as @e[tag=plm_ctx_target,limit=1,tag=!mirror_arena_boss] run function pld:pre/damage/public_damage_entity
tag @s add mirror_arena_damage_owner
execute as @e[tag=plm_ctx_target,limit=1,tag=mirror_arena_boss] run function plm:arena/hit/skill_armor
tag @s remove mirror_arena_damage_owner
tag @e[tag=plm_ctx_target,limit=1] remove mirror_affix_damage
tag @s remove mirror_affix_damage
tag @s remove if_death_count
