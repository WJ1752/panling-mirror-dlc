# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 #pld:equipment_lock/when_damaged（@s=受伤玩家）。
# 上下文：本体 pre/damage/reduce_health 末尾调用；此时 @s damage（×100）仍是本次受伤量，
#         会在 pre/damage/update 返回到调用方之后才 reset。
scoreboard players operation @s mirror_last_combat = #sys mirror_game_time
scoreboard players set @s mirror_fx_jing_xi_until 0
scoreboard players set @s mirror_fx_jing_xi_done 0
scoreboard players set @s mirror_fx_jing_xi_next 0

# 反照（受击概率使最近敌人减速 15% / 1s）
execute if score @s wp_affix_fx_fan_zhao matches 1.. run function plm:weapon/fx/fan_zhao
# 照心（镜统 0：受击 5% 概率反射 10% 伤害）
execute if score @s wp_set matches 0 run function plm:weapon/base/base_zhao_xin
