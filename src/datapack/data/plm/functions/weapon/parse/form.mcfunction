# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 器形编码：0 剑 / 1 斧 / 2 弓 / 3 弩 / 4 双生炉 / 5 拓印炉 / -1 未知
scoreboard players set @s mirror_form -1
execute if data storage plm:weapon item.tag{id:"panling:mirror_sword7"} run scoreboard players set @s mirror_form 0
execute if data storage plm:weapon item.tag{id:"panling:mirror_axe7"} run scoreboard players set @s mirror_form 1
execute if data storage plm:weapon item.tag{id:"panling:mirror_bow7"} run scoreboard players set @s mirror_form 2
execute if data storage plm:weapon item.tag{id:"panling:mirror_crossbow7"} run scoreboard players set @s mirror_form 3
execute if data storage plm:weapon item.tag{id:"panling:mirror_furnace_twin7"} run scoreboard players set @s mirror_form 4
execute if data storage plm:weapon item.tag{id:"panling:mirror_furnace_rub7"} run scoreboard players set @s mirror_form 5
