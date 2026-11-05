# 镜心减伤的实际支付：@s=玩家。
# 1.20.1 没有“受到伤害倍率”属性，而玩家 Health 不可写；这里用
# “每层 4% 的伤害折算成治疗债务，攒够 4 HP 用 instant_health I 返还”实现等价的减伤。
# 债务存在 mirror_shatter（2 位小数 HP，100=1HP），由 when_damaged 累加、本函数偿还。
# 最多一次偿还 8×4=32 HP；剩余债务留到下一次（避免大伤害时递归/爆栈）。
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches 400.. run effect give @s minecraft:instant_health 1 0 true
execute if score @s mirror_shatter matches 400.. run scoreboard players remove @s mirror_shatter 400
execute if score @s mirror_shatter matches ..-1 run scoreboard players set @s mirror_shatter 0
