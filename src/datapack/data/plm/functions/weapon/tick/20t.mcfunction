# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

execute as @a[tag=mirror_weapon_active] run function plm:weapon/fx/jing_xi
function plm:weapon/tick/bootstrap

# 已存在的影商随玩家接近时升级，兼容重载时尚未加载的区块。
execute at @a as @e[type=villager,tag=plm_merchant,tag=!plm_heart_trades,distance=..32] run function plm:mirror/hub/heart_trades
