# 镜花箭逐箭快照：@s=箭，@p[tag=shooter]=射手（route 调用时 shooter tag 仍在）。
# 参数存在箭自己身上，避免同一玩家第二支箭覆盖第一支箭的伤害/范围/目标数。
# 目标 objective 用法约定：
#   mirror_bloom_dmg    原箭 damage ×100（2 位小数 HP；100 = 1 HP），走护甲路径
#   mirror_bloom_range  绽放半径（8..10）
#   mirror_bloom_count  绽放目标槽数（2..4；99=真影律，8/9/10 格内所有敌人）
#   mirror_bloom_pct    第 3 槽强度（100..115，映水·强）
#   mirror_bloom_target 普通绽放强度（60..68，镜花·保）
#   mirror_bloom_extra  高强度槽序号（0=无；3=花影满第 3 槽；4=2 件套上限 5 时的第 4 槽）
#   mirror_bloom_5ticks 箭上剩余寿命（5t 单位，60 = 15s；卡住/未命中的保险）
#   mirror_flower_extra 花影·速概率快照（actual×10；flower_add 命中时读本箭，不读玩家当前值）
execute store result score @s mirror_bloom_dmg run data get entity @s damage 100
scoreboard players operation @s mirror_bloom_range = @p[tag=shooter] mirror_bloom_range
scoreboard players operation @s mirror_bloom_count = @p[tag=shooter] mirror_bloom_count
scoreboard players operation @s mirror_bloom_pct = @p[tag=shooter] mirror_bloom_pct
scoreboard players operation @s mirror_bloom_target = @p[tag=shooter] mirror_bloom_target
scoreboard players operation @s mirror_bloom_extra = @p[tag=shooter] mirror_bloom_extra
scoreboard players operation @s mirror_flower_extra = @p[tag=shooter] mirror_flower_extra

# 镜花 2 件套：每层花影 +2% 箭矢强度（只在上限 5 时生效；上限 3 的基础逻辑不变）。
# 直接改箭的 damage NBT，原始箭伤与绽放快照一起吃到加成。
scoreboard players set #bow_pct2 mirror_calc 100
execute if score @p[tag=shooter] mirror_flower_max matches 5 run scoreboard players operation #bow_pct2 mirror_calc += @p[tag=shooter] mirror_flower
execute if score @p[tag=shooter] mirror_flower_max matches 5 run scoreboard players operation #bow_pct2 mirror_calc += @p[tag=shooter] mirror_flower

# 镜花 4 件套：绽放后 5s 内下一支箭 +20%（mirror_bow_4_bonus=20），消费后清零。
scoreboard players set #bow4 mirror_calc 0
execute if score @p[tag=shooter] mirror_bow_4_until >= #sys mirror_game_time if score @p[tag=shooter] mirror_bow_4_bonus matches 1.. run scoreboard players set #bow4 mirror_calc 1
execute if score #bow4 mirror_calc matches 1 run scoreboard players operation #bow_pct2 mirror_calc += @p[tag=shooter] mirror_bow_4_bonus
execute if score #bow4 mirror_calc matches 1 run scoreboard players set @p[tag=shooter] mirror_bow_4_until 0
execute if score #bow4 mirror_calc matches 1 run scoreboard players set @p[tag=shooter] mirror_bow_4_bonus 0

scoreboard players operation @s mirror_bloom_dmg *= #bow_pct2 mirror_calc
scoreboard players operation @s mirror_bloom_dmg /= #const100 mirror_calc
# pct=100 时不写回 damage，避免把原箭的 3 位小数截断，保持 alpha.50 行为不变
execute unless score #bow_pct2 mirror_calc matches 100 if score @s mirror_bloom_dmg matches 1.. run execute store result entity @s damage double 0.01 run scoreboard players get @s mirror_bloom_dmg
scoreboard players set @s mirror_bloom_5ticks 60
tag @s add mirror_bloom_arrow
# 箭身青色镜光（一次起手闪光；飞行中的轻粒子在 bow/tick）
# 用 at @s 定位到箭本体，不能用执行位置（route 的 at @s 是玩家，会在玩家脚下爆粒子）
execute at @s run particle minecraft:dust 0.45 0.9 1 1 ~ ~ ~ 0.12 0.12 0.12 0.01 6
