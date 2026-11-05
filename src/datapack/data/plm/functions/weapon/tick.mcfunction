# 武器五纹 · 5t 主循环
# 1) 重解析当前生效武器（换武器 5t 内反映；不依赖 act:0）
# 2) 5t 特效（镜径/技能标记过期）
# 3) 20t 特效（镜息/吸收已激活镜武）
function plm:weapon/tick/refresh
function plm:weapon/tick/5t
function plm:mirror/skill/tick
scoreboard players add #sys mirror_tick20 1
execute if score #sys mirror_tick20 matches 4.. run function plm:weapon/tick/20t
execute if score #sys mirror_tick20 matches 4.. run scoreboard players set #sys mirror_tick20 0
schedule function plm:weapon/tick 5t replace

# 磨镜台冷却节流（10t 冷却 = 两次）
execute as @a[scores={wp_tbl_cool=1..}] run scoreboard players remove @s wp_tbl_cool 5
execute as @a[scores={wp_tbl_cool=..-1}] run scoreboard players set @s wp_tbl_cool 0
