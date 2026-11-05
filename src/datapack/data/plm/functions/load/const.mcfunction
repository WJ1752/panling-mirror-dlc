#=====================================================================
# 镜中倒影 · 全局常量表
# 改动规则：只改本文件，不要在各系统里散落数值
# 单位约定：*1 结尾 = ×10 定点（一位小数）；*_pct = 百分点整数
#=====================================================================

#---- 系统总开关（0=关闭，1=开启）----
scoreboard players set #sys mirror_on_mirror 1
scoreboard players set #sys mirror_on_endless 0
scoreboard players set #sys mirror_on_tide 0

#---- 镜铸：成本 ----
scoreboard players set #sys mirror_cost_polish_dust 10
scoreboard players set #sys mirror_cost_degree_dust 10
scoreboard players set #sys mirror_cost_dissolve_pct 60

#---- 映度（0..5）镜律数值倍率（%）----
scoreboard players set #sys mirror_degree_pct0 100
scoreboard players set #sys mirror_degree_pct1 110
scoreboard players set #sys mirror_degree_pct2 120
scoreboard players set #sys mirror_degree_pct3 135
scoreboard players set #sys mirror_degree_pct4 150
scoreboard players set #sys mirror_degree_pct5 170

#---- 镜律：数值参数（百分点，实际值 = 参数 × 映度倍率 / 100）----
scoreboard players set #sys mirror_law_echo 20
scoreboard players set #sys mirror_law_reflect 15
scoreboard players set #sys mirror_law_shatter 50
scoreboard players set #sys mirror_law_chain 150
scoreboard players set #sys mirror_law_mirror_cd 100
scoreboard players set #sys mirror_law_still 30
scoreboard players set #sys mirror_law_reverse 40
scoreboard players set #sys mirror_law_cleanse 40
scoreboard players set #sys mirror_law_shadowstep 5
scoreboard players set #sys mirror_law_heavy 30
scoreboard players set #sys mirror_law_broken 12
scoreboard players set #sys mirror_law_tide 50
scoreboard players set #sys mirror_law_guard 5
scoreboard players set #sys mirror_law_observe 2

#---- 镜域：镜深缩放（每层，百分点）----
scoreboard players set #sys mirror_depth_hp_pct 18
scoreboard players set #sys mirror_depth_dmg_pct 10
scoreboard players set #sys mirror_depth_loot_pct 15
scoreboard players set #sys mirror_depth_max_scaling 100

#---- 镜评 ----
scoreboard players set #sys mirror_rating_s 90
scoreboard players set #sys mirror_rating_a 75
scoreboard players set #sys mirror_rating_b 55
scoreboard players set #sys mirror_rating_loot_s 130
scoreboard players set #sys mirror_rating_loot_a 115
scoreboard players set #sys mirror_rating_loot_b 100
scoreboard players set #sys mirror_rating_loot_c 70
scoreboard players set #sys mirror_rating_penalty_time 5
scoreboard players set #sys mirror_rating_penalty_death 10
scoreboard players set #sys mirror_rating_penalty_room 15

#---- 镜潮 ----
scoreboard players set #sys mirror_tide_days 8

#---- 性能上限 ----
scoreboard players set #sys mirror_cap_entities 120
scoreboard players set #sys mirror_cap_markers 30
scoreboard players set #sys mirror_cap_arrows 20
scoreboard players set #sys mirror_cap_stands 12
