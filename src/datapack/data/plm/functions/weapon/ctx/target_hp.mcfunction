# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 输出 #wp mirror_wtmp = 目标生命百分比（0..100，整数）。@s=玩家，目标为 plm_ctx_target。
scoreboard players set #wp mirror_wtmp 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
scoreboard players set #wp mirror_wtmp2 0
scoreboard players set #wp mirror_wtmp3 0
execute store result score #wp mirror_wtmp2 run data get entity @e[tag=plm_ctx_target,limit=1] Health 1000
execute store result score #wp mirror_wtmp3 run attribute @e[tag=plm_ctx_target,limit=1] generic.max_health get 1000
execute if entity @e[tag=plm_ctx_target,tag=mirror_arena_boss,limit=1] run scoreboard players operation #wp mirror_wtmp2 = #boss mirror_boss_hp
execute if entity @e[tag=plm_ctx_target,tag=mirror_arena_boss,limit=1] run scoreboard players operation #wp mirror_wtmp3 = #boss mirror_boss_max
execute unless score #wp mirror_wtmp3 matches 1.. run return 0
scoreboard players operation #wp mirror_wtmp = #wp mirror_wtmp2
scoreboard players operation #wp mirror_wtmp *= #const100 mirror_calc
scoreboard players operation #wp mirror_wtmp /= #wp mirror_wtmp3
