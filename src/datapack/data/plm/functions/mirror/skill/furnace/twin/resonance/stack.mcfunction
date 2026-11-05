# 叠「共鸣」：@s = 主人玩家。
# 上限 3 层，双生 2 件套 +1 → 4 层；持续 15s（300 tick）；每层 +4% 阵法强度（词条 gong_ming_xiao 5.5%，在 echo/hit 里读）。
# #tw_shang = 1 表示本次 echo 的 gong_ming_shang 50% 判定成功，额外 +1 层。
# 过期在读取点判定（不挂全局实体 tick）。
execute unless score @s mirror_resonance_until >= #sys mirror_game_time run scoreboard players set @s mirror_resonance 0
scoreboard players add @s mirror_resonance 1
execute if score #tw_shang mirror_resonance_extra matches 1 run scoreboard players add @s mirror_resonance 1
scoreboard players set #tw_cap mirror_skill_tmp 3
execute if score @s mirror_set_count matches 2.. run scoreboard players set #tw_cap mirror_skill_tmp 4
execute if score @s mirror_resonance > #tw_cap mirror_skill_tmp run scoreboard players operation @s mirror_resonance = #tw_cap mirror_skill_tmp
scoreboard players operation @s mirror_resonance_until = #sys mirror_game_time
scoreboard players add @s mirror_resonance_until 300
