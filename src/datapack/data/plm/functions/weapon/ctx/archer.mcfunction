# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 #pld:archer_damage/multiply_base（射出时、archer_damage/update 内）。
# 此时没有目标，只能接自状态词条：逆鳞、余响。目标条件词条在弓/弩侧 Phase 1 deferred。
# 显式 job=1 守卫：本体 archer_damage/update 本身不检查职业，不能只依赖 mirror_form。
execute unless score @s job matches 1 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless score @s mirror_form matches 2..3 run return 0
execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0
function plm:weapon/dmg/archer/ni_lin
function plm:weapon/dmg/archer/yu_xiang
