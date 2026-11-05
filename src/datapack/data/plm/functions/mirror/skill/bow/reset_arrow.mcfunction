# 镜花箭逐箭记分板清理（review #25 / #26）
# @s=箭，必须在箭实体仍存在时调用。实体消失后 selector 选不到，UUID 条目无法再 reset。
# 清逐箭快照槽位 + 花影·速概率快照（mirror_flower_extra）
tag @s remove mirror_bloom_arrow
tag @s remove mirror_bloom_hit_arrow
scoreboard players reset @s mirror_bloom_dmg
scoreboard players reset @s mirror_bloom_range
scoreboard players reset @s mirror_bloom_count
scoreboard players reset @s mirror_bloom_pct
scoreboard players reset @s mirror_bloom_target
scoreboard players reset @s mirror_bloom_extra
scoreboard players reset @s mirror_bloom_5ticks
scoreboard players reset @s mirror_flower_extra
