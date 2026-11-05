# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 开发/测试：解析主手 SelectedItem → 玩家记分板（与 parse/apply 共用同一实现）
data modify storage plm:weapon item set value {}
execute if data entity @s SelectedItem run data modify storage plm:weapon item set from entity @s SelectedItem
execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/clear
# 激活的是非镜武时，不要把玩家另一槽位仍生效的镜武一并清掉：按当前 WeaponSlot 重解析。
execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/refresh
execute if data storage plm:weapon item.tag{mirror:1} run function plm:weapon/parse/apply
execute if data storage plm:weapon item.tag{mirror:1} run scoreboard players set @s mirror_walk_last 0
execute if data storage plm:weapon item.tag{mirror:1} run execute store result score @s mirror_walk_last run scoreboard players get @s mirror_walk_stat
