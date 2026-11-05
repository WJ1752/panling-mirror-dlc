# 武器五纹 · 数值常量（设计文档 §3.2 / §3.3 / §4.4 / §5.1 / §9.4）
# 单位：影尘/镜片/砂/核/缘 = 个；概率 = 百分点

# ---- 开纹成本：0→1 .. 4→5（§3.2）----
scoreboard players set #sys wp_cost_dust_0 10
scoreboard players set #sys wp_cost_dust_1 20
scoreboard players set #sys wp_cost_dust_2 35
scoreboard players set #sys wp_cost_dust_3 55
scoreboard players set #sys wp_cost_dust_4 80
scoreboard players set #sys wp_cost_shard_0 2
scoreboard players set #sys wp_cost_shard_1 4
scoreboard players set #sys wp_cost_shard_2 6
scoreboard players set #sys wp_cost_shard_3 8
scoreboard players set #sys wp_cost_shard_4 10
scoreboard players set #sys wp_cost_sand_0 0
scoreboard players set #sys wp_cost_sand_1 0
scoreboard players set #sys wp_cost_sand_2 1
scoreboard players set #sys wp_cost_sand_3 1
scoreboard players set #sys wp_cost_sand_4 2

# ---- 合成 / 分解 ----
scoreboard players set #sys wp_hundred 100
scoreboard players set #sys wp_craft_shard 4
scoreboard players set #sys wp_craft_dust 10
scoreboard players set #sys wp_dissolve_pct 60
scoreboard players set #sys wp_dissolve_min_shard 2

# ---- 洗练 / 淬纹 / 洗统（§3.4 / §4.4）----
scoreboard players set #sys wp_reroll_sand 1
scoreboard players set #sys wp_reroll_dust 30
scoreboard players set #sys wp_quench_core 1
scoreboard players set #sys wp_quench_dust 20
scoreboard players set #sys wp_set_edge_random 1
scoreboard players set #sys wp_set_dust_random 15
scoreboard players set #sys wp_set_edge_directed 2
scoreboard players set #sys wp_set_dust_directed 30

# ---- 品阶概率：下15 / 中35 / 上30 / 极15 / 绝5（§3.3）----
scoreboard players set #sys wp_tier_cut1 15
scoreboard players set #sys wp_tier_cut2 50
scoreboard players set #sys wp_tier_cut3 80
scoreboard players set #sys wp_tier_cut4 95
scoreboard players set #sys wp_tier_min1 50
scoreboard players set #sys wp_tier_span1 15
scoreboard players set #sys wp_tier_min2 65
scoreboard players set #sys wp_tier_span2 15
scoreboard players set #sys wp_tier_min3 80
scoreboard players set #sys wp_tier_span3 10
scoreboard players set #sys wp_tier_min4 90
scoreboard players set #sys wp_tier_span4 10
scoreboard players set #sys wp_tier_min5 100
scoreboard players set #sys wp_tier_span5 1

# ---- 洗练形状概率：A35 / B35 / C12 / D12 / E6（§5.1）----
scoreboard players set #sys wp_shape_cut1 35
scoreboard players set #sys wp_shape_cut2 70
scoreboard players set #sys wp_shape_cut3 82
scoreboard players set #sys wp_shape_cut4 94

# ---- 池大小（§6）----
scoreboard players set #sys wp_pool_dmg 12
scoreboard players set #sys wp_pool_skl 6
scoreboard players set #sys wp_pool_fx 10
