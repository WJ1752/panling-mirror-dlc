# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 卸下/非镜武：清空五纹解析并移除激活标记。保留全局击杀/战斗时间戳。
function plm:weapon/parse/clear
tag @s remove mirror_weapon_active
tag @s remove mirror_skill_active
scoreboard players set @s mirror_hit_seq 0
scoreboard players set @s mirror_ctx_extra 0
scoreboard players set @s mirror_walk_last 0
# 续影是「对同一玩家连续命中」的状态；换下武器即中断连击。
scoreboard players set @s mirror_xu_streak 0
scoreboard players set @s mirror_xu_target 0
# 镜息是武器特效：换下武器后重置本轮窗口，重新装备不会继承 done=1。
scoreboard players set @s mirror_fx_jing_xi_until 0
scoreboard players set @s mirror_fx_jing_xi_done 0
scoreboard players set @s mirror_fx_jing_xi_next 0
