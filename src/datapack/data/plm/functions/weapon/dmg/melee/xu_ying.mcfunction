# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 续影（xu_ying）— target
# 同一目标连续命中每层 +4%，上限 3 层；按玩家记录目标 uid，切换目标清零
execute unless score @s wp_affix_dmg_xu_ying matches 1.. run return 0
# 续影层数按玩家记录（mirror_xu_streak），由 on_hit 在命中后维护；
# 切换目标时 on_hit 会把层数清零，因此 A→B→A 不会保留 A 的旧层数。
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s mirror_xu_streak
scoreboard players operation #wp mirror_wtmp *= @s wp_affix_dmg_xu_ying
scoreboard players operation @s mirror_ctx_extra += #wp mirror_wtmp
