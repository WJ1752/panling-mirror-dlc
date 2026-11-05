# 被动「双生」的 1s 同中窗口：@s = 玩家，位置 = 主阵位置。
# 本体 metal_main 对每个 zf_hold_ldl 只用 limit=1 选最近目标（5/10 格，仅 monster）；
# 这里用 plm:mirror/skill/furnace/main_target 复选同一目标，而不是把 4 格内所有敌人都标成“同中”。
# owner 写进标记，防止 B 玩家消费 A 的标记。
# 2 件套：主阵命中本身也叠 1 层共鸣；4 件套满共鸣时给目标挂「相克」。
scoreboard players set #t mirror_set_tmp 4
function plm:mirror/set/can/tier
scoreboard players set #tw_2pc mirror_resonance_max 0
execute if score @s mirror_set_count matches 2.. run scoreboard players set #tw_2pc mirror_resonance_max 1
scoreboard players set #tw_4pc mirror_twin_4_until 0
execute if score @s mirror_set_4 matches 1 if score @s mirror_resonance_until >= #sys mirror_game_time if score @s mirror_resonance matches 3.. run scoreboard players set #tw_4pc mirror_twin_4_until 1

scoreboard players operation #tw_res_owner mirror_skill_tmp = @s player_uid
function plm:mirror/skill/furnace/main_target
execute at @s as @e[tag=mirror_main_target,sort=nearest,limit=1] run function plm:mirror/skill/furnace/twin/resonance/mark_one
# 2 件套：主阵有命中就叠 1 层（每座阵一次）
execute if entity @e[tag=mirror_main_target,limit=1] if score #tw_2pc mirror_resonance_max matches 1 run function plm:mirror/set/twin/stack_main
tag @e[tag=mirror_main_target] remove mirror_main_target
