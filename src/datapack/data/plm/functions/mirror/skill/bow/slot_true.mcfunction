# 真影律绽放：@s=射手；执行位置=命中箭。
# 真影律要求 4 件镜花防具映度全 5；此时 8/9/10 格内所有白名单敌人各吃一次普通绽放。
# 不生成新箭、不弹射；每个目标只结算一次。
tag @e[tag=mirror_bloom_true_hit] remove mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 8.. run tag @e[tag=monster,distance=..8] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 8.. run tag @e[tag=mirror_boss,distance=..8] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 8.. run tag @e[tag=mirror_summon,distance=..8] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 9.. run tag @e[tag=monster,distance=..9] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 9.. run tag @e[tag=mirror_boss,distance=..9] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 9.. run tag @e[tag=mirror_summon,distance=..9] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 10 run tag @e[tag=monster,distance=..10] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 10 run tag @e[tag=mirror_boss,distance=..10] add mirror_bloom_true_hit
execute if score #bow_range mirror_calc matches 10 run tag @e[tag=mirror_summon,distance=..10] add mirror_bloom_true_hit
tag @s add mirror_bloom_true_owner
execute as @e[tag=mirror_bloom_true_hit] run function plm:mirror/skill/bow/true_hit
tag @s remove mirror_bloom_true_owner
tag @e[tag=mirror_bloom_true_hit] remove mirror_bloom_true_hit
