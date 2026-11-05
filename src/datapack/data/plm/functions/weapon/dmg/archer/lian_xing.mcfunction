# 连星（lian_xing）— self（弓/弩命中侧）
# 每第 3 次命中 +20%；mirror_hit_seq 由 archer_hit 在命中后递增
execute unless score @s wp_affix_dmg_lian_xing matches 1.. run return 0
execute unless score @s mirror_hit_seq matches 2 run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_lian_xing
