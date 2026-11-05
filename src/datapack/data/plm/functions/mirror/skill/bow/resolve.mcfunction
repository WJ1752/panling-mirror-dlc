# 镜花绽放结算：@s=射手；执行位置=命中箭（bloom_hit / block_hit 用 execute at 箭 进入）。
# #bow_block：0=命中实体（可补打原目标），1=打方块（没有原目标）。
# 逐箭快照从 mirror_bloom_hit_arrow 上读，不读玩家身上的最新一次射击值。
tag @e[tag=mirror_bloom_skip] remove mirror_bloom_skip
tag @e[tag=mirror_bloom_victim] remove mirror_bloom_victim
tag @e[tag=mirror_bloom_done] remove mirror_bloom_done
tag @e[tag=mirror_bloom_cand] remove mirror_bloom_cand

# 原目标：命中点 2 格内刚受伤（HurtTime=10）的怪；致命一击时找不到，按无原目标处理
# 白名单：monster / mirror_boss / mirror_summon（CONTRACT §4）
execute if score #bow_block mirror_calc matches 0 run tag @e[tag=monster,nbt={HurtTime:10s},distance=..2,sort=nearest,limit=1] add mirror_bloom_victim
execute if score #bow_block mirror_calc matches 0 unless entity @e[tag=mirror_bloom_victim,limit=1] run tag @e[tag=mirror_boss,nbt={HurtTime:10s},distance=..2,sort=nearest,limit=1] add mirror_bloom_victim
execute if score #bow_block mirror_calc matches 0 unless entity @e[tag=mirror_bloom_victim,limit=1] run tag @e[tag=mirror_summon,nbt={HurtTime:10s},distance=..2,sort=nearest,limit=1] add mirror_bloom_victim
tag @e[tag=mirror_bloom_victim] add mirror_bloom_skip

# 逐箭参数 → scratch（箭若已消失则直接退出，避免拿上一次的 scratch 结算）
execute unless entity @e[tag=mirror_bloom_hit_arrow,limit=1] run return 0
scoreboard players operation #bow_dmg mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_dmg
scoreboard players operation #bow_range mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_range
scoreboard players operation #bow_count mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_count
scoreboard players operation #bow_pct mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_pct
scoreboard players operation #bow_splash mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_target
scoreboard players operation #bow_flower mirror_calc = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_extra

# 命中点镜面碎裂；打方块且周围无敌人时只有这一段
function plm:mirror/skill/bow/impact_fx

scoreboard players set #bow_hits mirror_calc 0

# 槽位：基础 2；花影满 3；镜花·弹 4。前 2 槽 60%（+镜花·保），
# 高强度槽 100%（+映水·强），弹槽仍 60%；不足目标时前 2 槽补原目标 50%。
# 真影律（count=99）：8/9/10 格内所有敌人各吃一次普通绽放，不再有目标数上限。
execute if score #bow_count mirror_calc matches 99 run function plm:mirror/skill/bow/slot_true
execute unless score #bow_count mirror_calc matches 99 run function plm:mirror/skill/bow/slot1
execute unless score #bow_count mirror_calc matches 99 run function plm:mirror/skill/bow/slot2
execute unless score #bow_count mirror_calc matches 99 if score #bow_count mirror_calc matches 3.. run function plm:mirror/skill/bow/slot3
execute unless score #bow_count mirror_calc matches 99 if score #bow_count mirror_calc matches 4.. run function plm:mirror/skill/bow/slot4

# 每个被绽放命中的目标 1 层花影（每箭基础最多 2 层；花影·速在 flower_add 里额外 +1）
execute if score #bow_hits mirror_calc matches 3.. run scoreboard players set #bow_hits mirror_calc 2
execute if score #bow_hits mirror_calc matches 1.. run function plm:mirror/skill/bow/flower_add
execute if score #bow_hits mirror_calc matches 2.. run function plm:mirror/skill/bow/flower_add

# 镜花 4 件套：绽放后 5s 内下一支箭 +20%
execute if score @s mirror_set_c matches 4.. run function plm:mirror/set/jing_hua/grant_4pc

# 消耗：穿透箭不二次绽放；箭已被本体正常结算，不生成/不保留任何实体
# 只消耗本次结算的那一支箭；不能用无 limit 的 tag 选择器把同 owner 的其它在飞箭一起摘掉
# 摘 tag + reset 逐箭记分板（review #25）：命中回调时箭实体仍在，reset 才能落到 UUID 条目上
execute as @e[tag=mirror_bloom_hit_arrow,limit=1] run function plm:mirror/skill/bow/reset_arrow
tag @e[tag=mirror_bloom_skip] remove mirror_bloom_skip
tag @e[tag=mirror_bloom_victim] remove mirror_bloom_victim
tag @e[tag=mirror_bloom_done] remove mirror_bloom_done
tag @e[tag=mirror_bloom_cand] remove mirror_bloom_cand
