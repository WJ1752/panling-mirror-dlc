# 借影（jie_ying）— 击杀概率复制目标 1 个增益，持续 3s（降级实现，明确口径）
# 限制：player_killed_entity reward 拿不到死者实体，无法在击杀时读 ActiveEffects。
# 采用「命中时快照」：plm:weapon/fx/jie_ying/snapshot 在目标存活时记录 ActiveEffects[0].Id
#   + 100t 有效期（mirror_jieying_id / mirror_jieying_until，按玩家记）。
# 击杀时按概率消费该快照，给玩家对应的**正面**原版增益 3s（固定 I 级，不复制等级与时长）。
execute unless score @s wp_affix_fx_jie_ying matches 1.. run return 0
execute unless score @s mirror_jieying_until >= #sys mirror_game_time run return 0
execute unless score @s mirror_jieying_id matches 1.. run return 0
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_fx_jie_ying
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
function plm:weapon/util/rand100
execute if score #t wp_rand > #wp mirror_wtmp run return 0

# 只复制正面增益（Id 白名单；等级统一 I，时长 3s）
execute if score @s mirror_jieying_id matches 1 run effect give @s minecraft:speed 3 0 true
execute if score @s mirror_jieying_id matches 3 run effect give @s minecraft:haste 3 0 true
execute if score @s mirror_jieying_id matches 5 run effect give @s minecraft:strength 3 0 true
execute if score @s mirror_jieying_id matches 8 run effect give @s minecraft:jump_boost 3 0 true
execute if score @s mirror_jieying_id matches 10 run effect give @s minecraft:regeneration 3 0 true
execute if score @s mirror_jieying_id matches 11 run effect give @s minecraft:resistance 3 0 true
execute if score @s mirror_jieying_id matches 12 run effect give @s minecraft:fire_resistance 3 0 true
execute if score @s mirror_jieying_id matches 13 run effect give @s minecraft:water_breathing 3 0 true
execute if score @s mirror_jieying_id matches 14 run effect give @s minecraft:invisibility 3 0 true
execute if score @s mirror_jieying_id matches 16 run effect give @s minecraft:night_vision 3 0 true
execute if score @s mirror_jieying_id matches 21 run effect give @s minecraft:health_boost 3 0 true
execute if score @s mirror_jieying_id matches 22 run effect give @s minecraft:absorption 3 0 true
execute if score @s mirror_jieying_id matches 23 run effect give @s minecraft:saturation 3 0 true
execute if score @s mirror_jieying_id matches 26 run effect give @s minecraft:luck 3 0 true
execute if score @s mirror_jieying_id matches 28 run effect give @s minecraft:slow_falling 3 0 true
execute if score @s mirror_jieying_id matches 29 run effect give @s minecraft:conduit_power 3 0 true
execute if score @s mirror_jieying_id matches 30 run effect give @s minecraft:dolphins_grace 3 0 true
execute if score @s mirror_jieying_id matches 32 run effect give @s minecraft:hero_of_the_village 3 0 true
execute as @s at @s run particle minecraft:dust 0.6 0.5 1 1 ~ ~1 ~ 0.3 0.5 0.3 0.02 12

# 快照只能消费一次
scoreboard players set @s mirror_jieying_id 0
scoreboard players set @s mirror_jieying_until 0
