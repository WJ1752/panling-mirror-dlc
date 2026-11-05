# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 #pld:attack_damage/multiply_base（body multiply_base 之后）。
# 上下文：@s=攻击玩家；warrior_tag 已被 check.mcfunction:2-5 标出；伤害尚未结算（check:26 才结算）。
# 这里只做三件事：
#   1) 自状态词条直接加 #attack_damage_multiply_base（同类相加）
#   2) 目标条件词条在伤害结算前读取目标状态，把“本次追加百分比×10”存进 @s mirror_ctx_extra
#   3) on_hit 用 mirror_ctx_extra 做一次带 mirror_affix_damage 的追加伤害
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless score @s mirror_form matches 0..1 run return 0
execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0
# 本体 attribute/update 对所有职业调用 multiply_base，但 job0/on_hit 只在 job=0 执行；这里显式守卫。
execute unless score @s job matches 0 run return 0
execute unless entity @e[tag=warrior_tag,limit=1] run return 0

# 目标选择 API：warrior_tag 优先；伤害路径不许走 fallback，故这里先确认 warrior_tag 存在。
function plm:weapon/ctx/target

# 续影：在伤害结算前确定本次目标；切换目标立即清零，避免新目标第一击吃到旧层数。
execute if entity @e[tag=plm_ctx_target,limit=1] unless score @e[tag=plm_ctx_target,limit=1] mirror_uid matches 1.. run scoreboard players add #sys mirror_uid_next 1
execute if entity @e[tag=plm_ctx_target,limit=1] unless score @e[tag=plm_ctx_target,limit=1] mirror_uid matches 1.. run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_uid = #sys mirror_uid_next
execute if entity @e[tag=plm_ctx_target,limit=1] unless score @s mirror_xu_target = @e[tag=plm_ctx_target,limit=1] mirror_uid run scoreboard players set @s mirror_xu_streak 0
execute if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation @s mirror_xu_target = @e[tag=plm_ctx_target,limit=1] mirror_uid

scoreboard players set @s mirror_ctx_extra 0
scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 0
# 借影：在伤害结算前（目标仍存活）记录 1 个增益快照，供击杀时复制
function plm:weapon/fx/jie_ying/snapshot
function plm:weapon/dmg/melee/po_xiao
function plm:weapon/dmg/melee/xu_ying
function plm:weapon/dmg/melee/ni_lin
function plm:weapon/dmg/melee/jing_xi
function plm:weapon/dmg/melee/zhui_ying
function plm:weapon/dmg/melee/lian_xing
function plm:weapon/dmg/melee/bei_zhao
function plm:weapon/dmg/melee/yu_xiang
function plm:weapon/dmg/melee/ying_ren
function plm:weapon/dmg/melee/su_feng
function plm:weapon/dmg/melee/shuang_zhao
function plm:weapon/dmg/melee/jing_shu
# FX 追加（目标条件）：镜痕 +5% / 照隙 +5% / 双影 10%
# 顺序在 DMG 之后：双照共鸣要先读到 mirror_zhaoxi_ready，再由 fx/zhao_xi 消费
function plm:weapon/fx/jing_hen
function plm:weapon/fx/zhao_xi
function plm:weapon/fx/shuang_ying
