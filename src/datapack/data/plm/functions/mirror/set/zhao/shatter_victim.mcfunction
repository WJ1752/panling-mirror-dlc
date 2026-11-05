# 碎镜命中单个敌人：@s=被命中的敌人。
# 伤害由 shatter 先算进 #zhao_dmg / #zhao_true；本函数负责：
#   1) 先按目标已有的易伤结算本次伤害（不会让本次碎镜给自己加 15%）；
#   2) 结算后再挂 3s 易伤时间戳（mirror_shatter_until）；
#   3) 以碎镜主人为攻击者，按真影律选择护甲/真伤包装。
tag @s add mirror_dmg_target
execute as @a[tag=mirror_shatter_owner,limit=1] run function plm:mirror/set/zhao/shatter_apply
execute if entity @s run scoreboard players operation @s mirror_shatter_until = #sys mirror_game_time
execute if entity @s run scoreboard players add @s mirror_shatter_until 60
tag @s remove mirror_dmg_target
execute at @s run particle minecraft:item minecraft:white_stained_glass ~ ~1 ~ 0.4 0.4 0.4 0.1 10
