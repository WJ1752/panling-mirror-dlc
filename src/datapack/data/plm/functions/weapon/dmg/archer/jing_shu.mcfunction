# 镜熟（jing_shu）— target（弓/弩命中侧）
# 对同一目标由同一玩家累计命中 >=10 后 +12%（mirror_xy_streak，on_hit/mark 维护）
execute unless score @s wp_affix_dmg_jing_shu matches 1.. run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_xy_streak matches 10.. run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_jing_shu
