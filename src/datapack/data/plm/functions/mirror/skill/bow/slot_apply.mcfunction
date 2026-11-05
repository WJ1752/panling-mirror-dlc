# 绽放一个槽位：@s=射手；执行位置=命中箭。
# 入参： #bow_slot_pct（对其他目标的强度%）、#bow_fb（补打原目标的强度%）
# 选 8/9/10 格内最近的「其它」怪（排除原目标与已结算目标）；不足时补原目标（#bow_fb）。
# 白名单：monster / mirror_boss / mirror_summon（CONTRACT §4）。
# 出参： #bow_hits（本次绽放实际命中的不同目标数，供花影层数使用）
tag @e[tag=mirror_bloom_cand] remove mirror_bloom_cand
tag @e[tag=mirror_bloom_pool] remove mirror_bloom_pool

# 先把 8/9/10 格内所有白名单目标汇进 pool，再统一取最近 1 个；
# 不能按 monster → boss → summon 顺序 fallback（会选到更远的低优先级目标）。
execute if score #bow_range mirror_calc matches 8.. run tag @e[tag=monster,tag=!mirror_bloom_skip,distance=..8] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 8.. run tag @e[tag=mirror_boss,tag=!mirror_bloom_skip,distance=..8] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 8.. run tag @e[tag=mirror_summon,tag=!mirror_bloom_skip,distance=..8] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 9.. run tag @e[tag=monster,tag=!mirror_bloom_skip,distance=..9] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 9.. run tag @e[tag=mirror_boss,tag=!mirror_bloom_skip,distance=..9] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 9.. run tag @e[tag=mirror_summon,tag=!mirror_bloom_skip,distance=..9] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 10 run tag @e[tag=monster,tag=!mirror_bloom_skip,distance=..10] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 10 run tag @e[tag=mirror_boss,tag=!mirror_bloom_skip,distance=..10] add mirror_bloom_pool
execute if score #bow_range mirror_calc matches 10 run tag @e[tag=mirror_summon,tag=!mirror_bloom_skip,distance=..10] add mirror_bloom_pool
tag @e[tag=mirror_bloom_pool,sort=nearest,limit=1] add mirror_bloom_cand
tag @e[tag=mirror_bloom_pool] remove mirror_bloom_pool

# 不足：补打原目标（打方块没有原目标，直接空过）
execute unless entity @e[tag=mirror_bloom_cand,limit=1] if entity @e[tag=mirror_bloom_victim,limit=1] run scoreboard players operation #bow_slot_pct mirror_calc = #bow_fb mirror_calc
execute unless entity @e[tag=mirror_bloom_cand,limit=1] run tag @e[tag=mirror_bloom_victim,limit=1] add mirror_bloom_cand
execute unless entity @e[tag=mirror_bloom_cand,limit=1] run return 0

# 同一目标反复补打只算 1 层花影
execute unless entity @e[tag=mirror_bloom_cand,limit=1,tag=mirror_bloom_done] run scoreboard players add #bow_hits mirror_calc 1
tag @e[tag=mirror_bloom_cand,limit=1] add mirror_bloom_done
tag @e[tag=mirror_bloom_cand,limit=1] add mirror_bloom_skip

# 伤害：原箭伤害（×100 的 2 位小数）× 槽位% / 100 → 护甲路径
# 先清旧 tag，保证 armor 的 limit=1 不会选到上一次结算残留的目标。
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
scoreboard players operation #temp entity_hurt_temp = #bow_dmg mirror_calc
scoreboard players operation #temp entity_hurt_temp *= #bow_slot_pct mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc
tag @e[tag=mirror_bloom_cand,limit=1] add mirror_dmg_target
tag @s add mirror_skill
function plm:mirror/set/zhao/vuln
function plm:mirror/damage/armor
tag @s remove mirror_skill

# 镜片飞向目标（不生成实体）
execute as @e[tag=mirror_bloom_cand,limit=1] at @s run particle minecraft:dust 0.45 0.9 1 1 ~ ~1 ~ 0.35 0.4 0.35 0.02 10
tag @e[tag=mirror_bloom_cand] remove mirror_bloom_cand
