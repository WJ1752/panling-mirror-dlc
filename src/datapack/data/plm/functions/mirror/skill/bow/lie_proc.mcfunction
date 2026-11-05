# 裂影 2 件套对镜花原箭命中的消费点：@s=射手；mirror_bloom_hit_arrow=本次命中的箭。
# 把原箭伤害换算成 #temp player_cause_1damage（×10，10=1HP），
# 再把箭的暴击标记交给 lie/on_hit 判断影伤是否暴击。
# 只对原箭命中触发一次；绽放溅射不重复触发。
execute unless entity @e[tag=mirror_bloom_hit_arrow,limit=1] run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_dmg matches 1.. run return 0
scoreboard players set #temp player_cause_1damage 0
scoreboard players operation #temp player_cause_1damage = @e[tag=mirror_bloom_hit_arrow,limit=1] mirror_bloom_dmg
scoreboard players operation #temp player_cause_1damage /= #const10 mirror_calc
# 直接读箭自身的 crit，避免玩家 mirror_arrow_crit 被下一箭覆盖/写入时序影响
scoreboard players set @s mirror_axe_2_crit 0
execute store result score @s mirror_axe_2_crit run data get entity @e[tag=mirror_bloom_hit_arrow,limit=1] crit
function plm:mirror/set/lie/on_hit
tag @e[tag=plm_ctx_target] remove plm_ctx_target
