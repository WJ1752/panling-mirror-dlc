# 花影 +1 层（每层一次；花影·速按快照概率额外 +1）。
# @s=射手；执行位置=命中箭（只用于 rand100 的临时掉落物，同 tick 清掉）。
# 持续 15s + 水月·久/5 ticks（500 → +100 ticks）。到期只在 route/resolve 触发点清。
scoreboard players add @s mirror_flower 1

# 花影·速：mirror_flower_extra 是 tag_arrow 逐箭快照的 wp_affix_skl_hua_ying_su（actual×10）
# 读命中的那支箭，不读玩家当前值：同一玩家第二支箭不会覆盖第一支（review #26）
# 先归 0，避免箭上分数缺失时 operation 静默失败、沿用 #bow_tmp 的上一次值
scoreboard players set #bow_tmp mirror_calc 0
scoreboard players operation #bow_tmp mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_flower_extra
scoreboard players operation #bow_tmp mirror_calc /= #const10 mirror_calc
execute if score #bow_tmp mirror_calc matches 1.. run function plm:weapon/util/rand100
execute if score #bow_tmp mirror_calc matches 1.. if score #t wp_rand matches 1.. if score #t wp_rand <= #bow_tmp mirror_calc run scoreboard players add @s mirror_flower 1

# 上限：2 件套 5，否则 3（plm:mirror/set/jing_hua/max）
function plm:mirror/set/jing_hua/max
execute if score @s mirror_flower > @s mirror_flower_max run scoreboard players operation @s mirror_flower = @s mirror_flower_max

# 到期时间：世界 gametime + 300 ticks + 水月·久（actual×10 → /5 ticks）
execute store result score #bow_now mirror_calc run time query gametime
scoreboard players operation @s mirror_flower_until = #bow_now mirror_calc
scoreboard players add @s mirror_flower_until 300
scoreboard players set #bow_tmp mirror_calc 0
scoreboard players operation #bow_tmp mirror_calc = @s wp_affix_skl_shui_yue_jiu
scoreboard players operation #bow_tmp mirror_calc *= #const2 mirror_calc
scoreboard players operation #bow_tmp mirror_calc *= #const10 mirror_calc
scoreboard players operation #bow_tmp mirror_calc /= #const100 mirror_calc
scoreboard players operation @s mirror_flower_until += #bow_tmp mirror_calc

# 满层：下一支镜花箭免费。
# 只写 mirror_bloom_free；不要清共享 mirror_cd_a（同职业的残影弩也用这个分数，
# 清 0 会把 150×5t 的弩冷却一起重置）。input/archer 已允许免费箭绕过 cd。
execute if score @s mirror_flower >= @s mirror_flower_max run scoreboard players set @s mirror_bloom_free 1
execute if score @s mirror_flower >= @s mirror_flower_max run execute at @s run particle minecraft:end_rod ~ ~1 ~ 0.5 0.6 0.5 0.04 16
execute if score @s mirror_flower >= @s mirror_flower_max run execute at @s run playsound minecraft:block.amethyst_cluster.break master @a ~ ~ ~ 0.7 1.9
