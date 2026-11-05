# 镜中倒影·影主竞技场 —— 加载入口
# 旧存档可能已设置 mirror_loaded 但只有部分灰盒计分板。独立的结构版本允许一次性补齐。
execute unless data storage plm:arena {schema:1} run function plm:arena/load/ensure
data remove storage plm:arena room.ready
execute if score #arena mirror_arena_run matches 0 run scoreboard players set #arena mirror_arena_active 0
scoreboard players set #arena mirror_loaded 1

# Bossbar 每次 reload 重建（避免 add 重复报错）
bossbar remove plm:mirror_boss
bossbar add plm:mirror_boss {"text":"影主","color":"white"}
bossbar set plm:mirror_boss color white
bossbar set plm:mirror_boss style notched_10
execute store result bossbar plm:mirror_boss max run scoreboard players get #boss mirror_boss_max
execute store result bossbar plm:mirror_boss value run scoreboard players get #boss mirror_boss_hp
bossbar set plm:mirror_boss visible false
execute if score #arena mirror_arena_active matches 1 run function plm:arena/bossbar/restore

