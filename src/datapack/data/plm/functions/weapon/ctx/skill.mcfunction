# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 #pld:equipment_lock/when_weapon_skill_enable（本体技能/阵法启用瞬间）。
# 记录技能上下文：mirror_skill_active 给 5t 清理用；mirror_skill_buff_until 是
# 「武器技增益已激活」的持久窗口（素锋 su_feng 的判定依据），实 buff 期间由 tick/5t 续期。
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0
tag @s add mirror_skill_active
scoreboard players operation @s mirror_skill_until = #sys mirror_game_time
scoreboard players add @s mirror_skill_until 20
scoreboard players operation @s mirror_skill_buff_until = #sys mirror_game_time
scoreboard players add @s mirror_skill_buff_until 60
