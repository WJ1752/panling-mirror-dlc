# @s=玩家；目标 plm_ctx_target；#temp entity_hurt_temp=本次直接命中（×100，2 位小数）
# 影伤 = 本次直接命中 × mirror_axe_ratio%（9..12%）
# 单位：#temp 是伤害 ×100；mirror_axe_ratio 是百分点 ×10（90=9%，120=12%）。
# 100 × 10 = 1000，必须除以 #const1000 才是真正的百分比。
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
scoreboard players operation #skill mirror_skill_tmp = #temp entity_hurt_temp
scoreboard players operation #skill mirror_skill_tmp *= @s mirror_axe_ratio
scoreboard players operation #skill mirror_skill_tmp /= #const1000 mirror_calc

# 影伤队列：marker 只是“延迟结算点”，带 owner 以便主人死亡/换维度后清理。
execute at @e[tag=plm_ctx_target,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["mirror_shadow_hit","mirror_shadow_hit_new"]}
scoreboard players operation @e[tag=mirror_shadow_hit_new,limit=1] mirror_shadow_hit_dmg = #skill mirror_skill_tmp
scoreboard players operation @e[tag=mirror_shadow_hit_new,limit=1] mirror_shadow_hit_due = @s mirror_axe_delay
scoreboard players operation @e[tag=mirror_shadow_hit_new,limit=1] mirror_shadow_hit_owner = @s player_uid
tag @e[tag=mirror_shadow_hit_new] remove mirror_shadow_hit_new

# 每玩家队列上限 32：超出时杀一个自己的 marker（同维度）
scoreboard players add @s mirror_ch_queue 1
execute if score @s mirror_ch_queue matches 33.. run function plm:mirror/skill/axe/chongying/trim
