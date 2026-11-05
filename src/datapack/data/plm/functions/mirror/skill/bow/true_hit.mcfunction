# 真影律绽放命中单个敌人：@s=敌人；#bow_dmg/#bow_splash 由 resolve 快照。
# 以镜花主人为攻击者走护甲包装；碎镜易伤在伤害前乘 1.15。
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
scoreboard players operation #temp entity_hurt_temp = #bow_dmg mirror_calc
scoreboard players operation #temp entity_hurt_temp *= #bow_splash mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
tag @s add mirror_dmg_target
scoreboard players add #bow_hits mirror_calc 1
execute as @a[tag=mirror_bloom_true_owner,limit=1] run function plm:mirror/set/zhao/vuln
execute as @a[tag=mirror_bloom_true_owner,limit=1] run function plm:mirror/damage/armor
tag @s remove mirror_dmg_target
execute at @s run particle minecraft:dust 0.45 0.9 1 1 ~ ~1 ~ 0.35 0.4 0.35 0.02 10
