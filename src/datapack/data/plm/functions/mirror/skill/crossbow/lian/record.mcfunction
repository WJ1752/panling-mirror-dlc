# 连影 · 计数核心（@s=射手；目标已打 mirror_lian_hit_target）
# 输入：#lian_nopower mirror_skill_perfect = 0 玩家自己的箭 / 1 弩机箭（不计第 4 发重影）
# 5s 窗口在这里读时判定；同 tick 去重也在这一层，供 advancement 与直接结算共用。
execute unless score @s job matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0
execute unless entity @e[tag=monster,tag=mirror_lian_hit_target,limit=1] unless entity @e[tag=mirror_boss,tag=mirror_lian_hit_target,limit=1] unless entity @e[tag=mirror_summon,tag=mirror_lian_hit_target,limit=1] run return 0

# 同 tick 去重：上一次成功处理把 until 写成 game_time+100；同一 tick 再来就丢弃。
scoreboard players operation #last mirror_skill_tmp = @s mirror_lian_until
scoreboard players remove #last mirror_skill_tmp 100
execute if score #last mirror_skill_tmp = #sys mirror_game_time run return 0

# 5s 窗口过期：计数与下一箭穿透预置一起清
execute if score @s mirror_lian_until < #sys mirror_game_time run scoreboard players set @s mirror_lian 0
execute if score @s mirror_lian_until < #sys mirror_game_time run scoreboard players set @s mirror_lian_target 0
execute if score @s mirror_lian_until < #sys mirror_game_time run scoreboard players set @s mirror_lian_next_pierce 0

scoreboard players operation @s mirror_lian_until = #sys mirror_game_time
scoreboard players add @s mirror_lian_until 100
execute store result score #cbt mirror_skill_tmp run data get entity @e[tag=mirror_lian_hit_target,limit=1,sort=nearest] UUID[0]

# 换目标清零
execute unless score @s mirror_lian_target = #cbt mirror_skill_tmp run scoreboard players set @s mirror_lian 0
execute unless score @s mirror_lian_target = #cbt mirror_skill_tmp run scoreboard players set @s mirror_lian_next_pierce 0
scoreboard players operation @s mirror_lian_target = #cbt mirror_skill_tmp

# 第 3 次命中（进入前累计 2）：给下一支玩家箭预置穿透
execute if score @s mirror_lian matches 2 run scoreboard players set @s mirror_lian_next_pierce 2
execute if score @s mirror_lian matches 2 run scoreboard players operation #add mirror_skill_tmp3 = @s wp_affix_skl_chong_ying_chuan
execute if score @s mirror_lian matches 2 run scoreboard players operation #add mirror_skill_tmp3 /= #const100 mirror_calc
execute if score @s mirror_lian matches 2 run scoreboard players operation @s mirror_lian_next_pierce += #add mirror_skill_tmp3

# 已累计 3 次 -> 本次是第 4 发；弩机箭（#lian_nopower=1）不触发重影，计数停在 3 等玩家自己的箭
execute if score #lian_nopower mirror_skill_perfect matches 0 if score @s mirror_lian matches 3.. run function plm:mirror/skill/crossbow/lian/power
execute if score @s mirror_lian matches ..2 run scoreboard players add @s mirror_lian 1
