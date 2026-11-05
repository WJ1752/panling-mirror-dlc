# @s=玩家；目标 plm_ctx_target；#temp entity_hurt_temp=本次直接命中（×100，2 位小数）
# 设计 §2.2.1：3 层、每层独立 6s；第 3 层立刻引爆。
execute unless score @s mirror_form matches 1 run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0

# 逐层过期（不做全局 @e tick，只在命中/引爆时处理）
execute as @e[tag=plm_ctx_target,limit=1] run function plm:weapon/axe/lie/expire

# 环形槽：i = 1/2/0（第 1/2/3 层），每层存自己的 damage 与时间戳
scoreboard players add @e[tag=plm_ctx_target,limit=1] mirror_lie_i 1
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 3.. run scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_lie_i 0

execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 1 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_dmg += #temp entity_hurt_temp
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 1 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_w1 = #temp entity_hurt_temp
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 1 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_t1 = #sys mirror_game_time
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 2 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_dmg += #temp entity_hurt_temp
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 2 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_w2 = #temp entity_hurt_temp
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 2 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_t2 = #sys mirror_game_time
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 0 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_dmg += #temp entity_hurt_temp
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 0 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_w3 = #temp entity_hurt_temp
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie_i matches 0 run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_t3 = #sys mirror_game_time

scoreboard players add @e[tag=plm_ctx_target,limit=1] mirror_lie 1
execute if score @e[tag=plm_ctx_target,limit=1] mirror_lie matches 4.. run scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_lie 3

# 计时展示用：最近一层的到期时间 = now + 120 + 裂续/5（max 200 → +40 tick = +2s）
scoreboard players operation #wp mirror_wtmp = #sys mirror_game_time
scoreboard players add #wp mirror_wtmp 120
scoreboard players set #wp2 mirror_wtmp2 0
scoreboard players operation #wp2 mirror_wtmp2 = @s wp_affix_skl_lie_xu
scoreboard players operation #wp2 mirror_wtmp2 *= #const2 mirror_calc
scoreboard players operation #wp2 mirror_wtmp2 /= #const10 mirror_calc
scoreboard players operation #wp mirror_wtmp += #wp2 mirror_wtmp2
scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_until = #wp mirror_wtmp

execute at @e[tag=plm_ctx_target,limit=1] run particle minecraft:crit ~ ~1 ~ 0.3 0.3 0.3 0.02 4
execute if entity @e[tag=plm_ctx_target,limit=1] if score @e[tag=plm_ctx_target,limit=1] mirror_lie matches 3.. run function plm:weapon/axe/lie/explode
