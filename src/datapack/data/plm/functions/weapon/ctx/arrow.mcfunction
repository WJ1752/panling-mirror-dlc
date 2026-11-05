# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 挂在 #pld:archer/the_arrow（set_damage.mcfunction:22）。
# 上下文：@s=箭，@p[tag=shooter]=射手。set_damage:6-10 已写 damage 并按 weapon_arrow_crit 处理 crit。
# Phase 1 只做上下文快照（暴击/箭伤标记），不实现镜隙 DMG（设计 v1 停用）。
execute unless entity @p[tag=shooter] run return 0
execute unless entity @p[tag=shooter,tag=mirror_weapon_active] run return 0
execute unless score @p[tag=shooter] mirror_form matches 2..3 run return 0
execute unless data entity @p[tag=shooter] SelectedItem.tag{mirror:1,act:1} run return 0
tag @s add mirror_arrow
scoreboard players set @p[tag=shooter] mirror_arrow_crit 0
execute store result score @p[tag=shooter] mirror_arrow_crit run data get entity @s crit
execute store result score @p[tag=shooter] mirror_arrow_damage run data get entity @s damage 100
# 真实箭命中后实体可能已消失；把本次箭伤/时间存到射手，ranged/hit 可回退
execute store result score @p[tag=shooter] mirror_last_ranged_dmg run data get entity @s damage 10
scoreboard players operation @p[tag=shooter] mirror_last_ranged_until = #sys mirror_game_time
scoreboard players add @p[tag=shooter] mirror_last_ranged_until 40
scoreboard players operation @p[tag=shooter] mirror_last_combat = #sys mirror_game_time

# 连影：第 3 次命中后写入 mirror_lian_next_pierce；第 4 支箭必须在出膛时
# 就带上 PierceLevel（命中回调里再加已经晚了，箭已经停住）。
execute if score @p[tag=shooter] mirror_lian_next_pierce matches 1.. unless score @p[tag=shooter] mirror_lian_until >= #sys mirror_game_time run scoreboard players set @p[tag=shooter] mirror_lian_next_pierce 0
execute if score @p[tag=shooter] mirror_lian_next_pierce matches 1.. if score @p[tag=shooter] mirror_lian_until >= #sys mirror_game_time store result entity @s PierceLevel byte 1 run scoreboard players get @p[tag=shooter] mirror_lian_next_pierce
execute if score @p[tag=shooter] mirror_lian_next_pierce matches 1.. if score @p[tag=shooter] mirror_lian_until >= #sys mirror_game_time run scoreboard players set @p[tag=shooter] mirror_lian_next_pierce 0
