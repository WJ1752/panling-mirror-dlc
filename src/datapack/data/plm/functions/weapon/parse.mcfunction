# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 激活入口。上下文：@s=玩家，位置在玩家，待激活物品在本体 equipment_lock 的 ~ 255 ~ chest Items[0]。
# 本体在 enable/main.mcfunction:22 无条件调用 #pld:weapon_unlock/enchant（type:1），本函数挂在那个标签里。
data modify storage plm:weapon item set value {}
execute if data block ~ 255 ~ Items[0] run data modify storage plm:weapon item set from block ~ 255 ~ Items[0]
execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/clear
# 激活的是非镜武时，不要把玩家另一槽位仍生效的镜武一并清掉：按当前 WeaponSlot 重解析。
execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/refresh
execute if data storage plm:weapon item.tag{mirror:1} run function plm:weapon/parse/apply

# 重新激活时把镜径采样基准对齐到当前 walk_one_cm
execute if data storage plm:weapon item.tag{mirror:1} run scoreboard players set @s mirror_walk_last 0
execute if data storage plm:weapon item.tag{mirror:1} run execute store result score @s mirror_walk_last run scoreboard players get @s mirror_walk_stat
