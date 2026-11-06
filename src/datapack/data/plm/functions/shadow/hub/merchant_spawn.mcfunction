# 回城marker和merchant spot分离，实体只在指定商位生成。
execute in minecraft:overworld at @e[type=marker,tag=plm_shadow_merchant_spot,limit=1] unless entity @e[type=villager,tag=plm_merchant,distance=..4,limit=1] run function plm:mirror/hub/merchant
execute in minecraft:overworld at @e[type=marker,tag=plm_shadow_merchant_spot,limit=1] as @e[type=villager,tag=plm_merchant,tag=!plm_shadow_merchant_ready,distance=..4,limit=1] run function plm:shadow/hub/merchant_fix
