# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 #pld:warrior/when_hurt_entity（job0.mcfunction:18）。
# 上下文：@s=玩家；warrior_tag 仍在（check:37 才清）；#temp player_cause_1damage = attack_damage1（×10 定点）。
# 目标条件词条已在 ctx/melee 里按伤害结算前的目标状态累加进 @s mirror_ctx_extra（百分比×10）。
execute if entity @s[tag=mirror_affix_damage] run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0
# 本体 check 只给 tag=monster 打 warrior_tag；镜主只有 mirror_boss tag。
# 不能覆盖 pld body（静态检查禁止 data/pld/functions/**），因此这里放行
# “5 格内刚被命中的 mirror_boss / mirror_summon”，再由 ctx/target 的 boss fallback 选中。
execute unless entity @e[tag=warrior_tag,limit=1] unless entity @e[tag=mirror_boss,nbt={HurtTime:10s},distance=..5,limit=1] unless entity @e[tag=mirror_summon,nbt={HurtTime:10s},distance=..5,limit=1] run return 0

# 目标选择 API（warrior_tag 优先；boss/summon 命中时走 fallback）
function plm:weapon/ctx/target
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0

# 裂影基底：5% 概率 +10% 影伤（与五纹追加伤害合并成一次，避免多次触发 when_cause_damage）
function plm:weapon/base/base_lie_ying

# 追加伤害：mirror_ctx_extra 单位 = 百分点×10；extra_apply 内部换算成 100/HP 定点。
# 目标条件 FX（镜痕/照隙/双影）已在 ctx/melee 累加进 mirror_ctx_extra，这里不重复调用，
# 否则同一次近战命中会把 +5%/+10% 结算两次。
execute if score @s mirror_ctx_extra matches 1.. run function plm:weapon/dmg/extra_apply
scoreboard players set @s mirror_ctx_extra 0

# 目标计数（续影/镜熟/镜痕/照隙）
scoreboard players operation #wp mirror_wtmp = @s player_uid
execute as @e[tag=plm_ctx_target,limit=1] run function plm:weapon/on_hit/mark

# 命中后状态：镜痕留痕（3 次后 5s）/ 照隙发光与「下一次受伤 +5%」/ 借影增益快照
function plm:weapon/fx/jing_hen/mark
function plm:weapon/fx/zhao_xi/proc
function plm:weapon/fx/jie_ying/snapshot

# 续影：切换目标清零。以目标 mirror_uid 判定「同一目标」；层数在本次命中后递增。
# 目标被追加伤害击杀时实体已不存在，必须清空玩家状态，否则下一击会把旧层数带过去。
execute unless entity @e[tag=plm_ctx_target,limit=1] run scoreboard players set @s mirror_xu_streak 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run scoreboard players set @s mirror_xu_target 0
execute if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation #wp mirror_wtmp2 = @e[tag=plm_ctx_target,limit=1] mirror_uid
execute if entity @e[tag=plm_ctx_target,limit=1] unless score @s mirror_xu_target = #wp mirror_wtmp2 run scoreboard players set @s mirror_xu_streak 0
execute if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation @s mirror_xu_target = #wp mirror_wtmp2
execute if entity @e[tag=plm_ctx_target,limit=1] if score @s mirror_xu_streak matches ..2 run scoreboard players add @s mirror_xu_streak 1

# 连星：每次成功近战 +1，3 次一循环（ctx 读 seq==2 时为第 3 击）
scoreboard players add @s mirror_hit_seq 1
execute if score @s mirror_hit_seq matches 3.. run scoreboard players set @s mirror_hit_seq 0
scoreboard players operation @s mirror_last_combat = #sys mirror_game_time

# 裂影斧：裂痕层数 + 重影影伤队列
execute if score @s mirror_form matches 1 run function plm:weapon/axe/lie_hit
execute if score @s mirror_form matches 1 if score @s mirror_chongying_5ticks matches 1.. run function plm:weapon/axe/chongying/on_hit
# 照心剑：踏影 buff 期间的额外镜伤 / 加成
execute if score @s mirror_form matches 0 if score @s mirror_taying_buff matches 1.. run function plm:mirror/skill/sword/on_hit
# 镜统 2/4 件套命中/击杀入口
function plm:mirror/set/on_hit
