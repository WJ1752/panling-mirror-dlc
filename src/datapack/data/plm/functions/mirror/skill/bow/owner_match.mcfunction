# 单支箭的 owner 匹配：@s=箭；#bow_uid0..3=射手 UUID 分量（route 已快照）。
# 读箭自身的 Owner（原版玩家射出的箭必写）；没有 Owner 的箭（发射器/骷髅等）直接跳过。
# 匹配成功打 mirror_bloom_new，由 route 取最近一支后交给 tag_arrow。
execute unless data entity @s Owner run return 0
scoreboard players set #arrow_uid0 mirror_calc 0
scoreboard players set #arrow_uid1 mirror_calc 0
scoreboard players set #arrow_uid2 mirror_calc 0
scoreboard players set #arrow_uid3 mirror_calc 0
execute store result score #arrow_uid0 mirror_calc run data get entity @s Owner[0]
execute store result score #arrow_uid1 mirror_calc run data get entity @s Owner[1]
execute store result score #arrow_uid2 mirror_calc run data get entity @s Owner[2]
execute store result score #arrow_uid3 mirror_calc run data get entity @s Owner[3]
execute if score #arrow_uid0 mirror_calc = #bow_uid0 mirror_calc if score #arrow_uid1 mirror_calc = #bow_uid1 mirror_calc if score #arrow_uid2 mirror_calc = #bow_uid2 mirror_calc if score #arrow_uid3 mirror_calc = #bow_uid3 mirror_calc run tag @s add mirror_bloom_new
