# 分影单维度 5t：owner 丢失清理、寿命、攻击、跟随
# owner 判定先做：主人死亡/换维度/重登后倒影立即消失，不再继续攻击。
# 每个选择器都必须带 distance=0..：裸 @e 是跨维度的，distance 把匹配锚在执行维度，
# 这样 tick 的三次逐维度调用中，每个倒影只会在它自己的维度被处理一次。
execute as @e[tag=mirror_shadow,distance=0..] at @s run function plm:mirror/skill/shadow/owner_check
scoreboard players remove @e[tag=mirror_shadow,distance=0..] mirror_shadow_5ticks 1
execute as @e[tag=mirror_shadow,distance=0..,scores={mirror_shadow_5ticks=..0}] at @s run function plm:mirror/skill/shadow/end
scoreboard players remove @e[tag=mirror_shadow,distance=0..] mirror_shadow_atk_timer 1
execute as @e[tag=mirror_shadow,distance=0..,scores={mirror_shadow_atk_timer=..0}] at @s run function plm:mirror/skill/shadow/attack
scoreboard players remove @e[tag=mirror_shadow,distance=0..] mirror_shadow_move_timer 1
execute as @e[tag=mirror_shadow,distance=0..,scores={mirror_shadow_move_timer=..0}] at @s run function plm:mirror/skill/shadow/move
