# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 镜熟（jing_shu）— target
# 对同一目标由同一玩家累计命中 >=10 后 +12%（mirror_xy_streak，on_hit/mark 维护）
execute unless score @s wp_affix_dmg_jing_shu matches 1.. run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_xy_streak matches 10.. run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_jing_shu
