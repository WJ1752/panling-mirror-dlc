# 拓印 4 件套：放印后 5s 内下一次本体阵法 +5%
# @s=玩家；由 rub/after_main|off 在写完 mirror_zf_base 后调用。
# 1.20.1 无法在 after 钩子里回改本体已结算的 zf_str，所以这里按“同一目标补 5% 阵法伤害”实现；
# 目标仍取本体金属阵的最近目标（5/10 格按 zf_hold_ldl），伤害走 DLC true 管线（不吃护甲，吃 Resistance）。
execute unless score @s mirror_rub_next_bonus matches 1.. run return 0
scoreboard players set #t mirror_set_tmp 5
function plm:mirror/set/can/tier
execute unless score @s mirror_set_4 matches 1 run scoreboard players set @s mirror_rub_next_bonus 0
execute unless score @s mirror_set_4 matches 1 run return 0
# 5s 窗口过期 -> 作废
execute if score @s mirror_rub_next_bonus < #sys mirror_game_time run scoreboard players set @s mirror_rub_next_bonus 0
execute if score @s mirror_rub_next_bonus < #sys mirror_game_time run return 0
# 只有金属主阵造成伤害；没有快照/没命中就只消费
execute unless score @s mirror_zf_main_el matches 1 run scoreboard players set @s mirror_rub_next_bonus 0
execute unless score @s mirror_zf_main_el matches 1 run return 0
execute unless score @s mirror_zf_base matches 1.. run scoreboard players set @s mirror_rub_next_bonus 0
execute unless score @s mirror_zf_base matches 1.. run return 0

# mirror_zf_base 是 0.1 HP 定点；5% 换算成 true 管线的 4 位小数（10000=1HP）= base×50
scoreboard players operation #temp entity_hurt_temp = @s mirror_zf_base
scoreboard players operation #temp entity_hurt_temp *= #const100 mirror_calc
scoreboard players operation #temp entity_hurt_temp /= #const2 mirror_calc

# 目标：after_main/off 已用 plm:mirror/skill/furnace/main_target 按本体 metal_main 的
# zf_hold_ldl 5/10 格规则标出本次主阵实际目标（tag=mirror_main_target）。
# 目标被主阵击杀时这里选不到：保留 +5% 窗口到下一次阵法，不静默消费。
execute unless entity @e[tag=mirror_main_target,limit=1] run return 0

# 与本体金属阵一致：in30_boss4 的阵法减伤 20%
execute if entity @e[tag=mirror_main_target,limit=1,tag=in30_boss4] run scoreboard players operation #temp entity_hurt_temp *= #const2 mirror_calc
execute if entity @e[tag=mirror_main_target,limit=1,tag=in30_boss4] run scoreboard players operation #temp entity_hurt_temp /= #const10 mirror_calc

execute at @s run tag @e[tag=mirror_main_target,limit=1] add mirror_dmg_target
execute at @e[tag=mirror_main_target,limit=1] run particle minecraft:dust 1 0.82 0.25 1 ~ ~1 ~ 0.4 0.4 0.4 0.02 10
# 本体金属阵是直接扣血（吃 Resistance、不吃护甲）；用 DLC true 管线复刻这一口径。
function plm:mirror/damage/true
tag @e[tag=mirror_main_target] remove mirror_main_target
# 命中同一主阵目标后才消费“下一阵法 +5%”
scoreboard players set @s mirror_rub_next_bonus 0
