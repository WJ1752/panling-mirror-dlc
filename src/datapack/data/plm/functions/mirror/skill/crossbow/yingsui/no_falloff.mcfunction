# 残影 4 件套：30% 齐射箭不衰减
# @s=玩家；对刚生成的 mirror_shot_new 箭掷一次 1..100。
function plm:weapon/util/rand100
scoreboard players set #tw_rand_cap mirror_set_tmp 30
execute if score #t wp_rand <= #tw_rand_cap mirror_set_tmp run tag @e[tag=mirror_shot_new,limit=1] add mirror_no_falloff
