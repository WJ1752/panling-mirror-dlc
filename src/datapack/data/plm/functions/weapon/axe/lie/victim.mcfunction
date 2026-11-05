# @s=被裂痕波及的敌人
# #temp 在 victim 上下文写入（fake score 跨 execute as 保留），再切回攻击者调护甲包装。
scoreboard players operation #temp entity_hurt_temp = #skill mirror_skill_lie
tag @s add mirror_dmg_target
execute as @a[tag=mirror_lie_attacker,limit=1] run function plm:mirror/set/zhao/vuln
execute as @a[tag=mirror_lie_attacker,limit=1] run function plm:mirror/damage/armor
execute at @s run particle minecraft:dust 0.9 0.1 0.1 1 ~ ~1 ~ 0.3 0.3 0.3 0.03 8
