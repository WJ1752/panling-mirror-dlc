# 镜花 2 件套：普通弓箭命中 +1 花影（专属镜花箭走 bloom_hit/resolve，不走这里）。
# @s=射手；执行位置=命中箭（只影响粒子/rand100 的临时掉落物）。
# 2 件套才叠；上限 5，15s + 水月·久 刷新。
execute unless score @s mirror_set_c matches 1.. run return 0
function plm:mirror/set/jing_hua/max
execute unless score @s mirror_set_count matches 2.. run return 0
scoreboard players add @s mirror_flower 1

# 花影·速：普通箭没有逐箭快照，读玩家当前词条（/10 得百分比）
scoreboard players set #jh_tmp mirror_calc 0
scoreboard players operation #jh_tmp mirror_calc = @s wp_affix_skl_hua_ying_su
scoreboard players operation #jh_tmp mirror_calc /= #const10 mirror_calc
execute if score #jh_tmp mirror_calc matches 1.. run function plm:weapon/util/rand100
execute if score #jh_tmp mirror_calc matches 1.. if score #t wp_rand matches 1.. if score #t wp_rand <= #jh_tmp mirror_calc run scoreboard players add @s mirror_flower 1

function plm:mirror/set/jing_hua/max
execute if score @s mirror_flower > @s mirror_flower_max run scoreboard players operation @s mirror_flower = @s mirror_flower_max

# 刷新 15s + 水月·久（同上：wp_affix_skl_shui_yue_jiu ×20/100 ticks）
scoreboard players operation @s mirror_flower_until = #sys mirror_game_time
scoreboard players add @s mirror_flower_until 300
scoreboard players set #jh_tmp mirror_calc 0
scoreboard players operation #jh_tmp mirror_calc = @s wp_affix_skl_shui_yue_jiu
scoreboard players operation #jh_tmp mirror_calc *= #const2 mirror_calc
scoreboard players operation #jh_tmp mirror_calc *= #const10 mirror_calc
scoreboard players operation #jh_tmp mirror_calc /= #const100 mirror_calc
scoreboard players operation @s mirror_flower_until += #jh_tmp mirror_calc

execute if score @s mirror_flower >= @s mirror_flower_max run scoreboard players set @s mirror_bloom_free 1
execute if score @s mirror_flower >= @s mirror_flower_max run execute at @s run particle minecraft:end_rod ~ ~1 ~ 0.5 0.6 0.5 0.04 16
execute if score @s mirror_flower >= @s mirror_flower_max run execute at @s run playsound minecraft:block.amethyst_cluster.break master @a ~ ~ ~ 0.7 1.9
