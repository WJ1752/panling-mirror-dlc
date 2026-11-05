# @s = 箭（at 箭）。从箭的位置标记刚命中的白名单目标。
# 1.20.1 的 NBT 选择器不支持 HurtTime 数值范围，因此按「最近目标 + 读 HurtTime 分数 >0」判定。
# 与 plm:mirror/ranged/mark_target 同口径，但只打候选 tag（wp_ranged_cand），
# 由 archer_hit 统一定成一个目标，避免多箭时 limit=1 任选。
scoreboard players set #wp mirror_wtmp2 0
execute as @e[tag=monster,distance=..4,sort=nearest,limit=1] store result score #wp mirror_wtmp2 run data get entity @s HurtTime
execute if score #wp mirror_wtmp2 matches 1.. as @e[tag=monster,distance=..4,sort=nearest,limit=1] run tag @s add wp_ranged_cand
scoreboard players set #wp mirror_wtmp2 0
execute as @e[tag=mirror_boss,distance=..4,sort=nearest,limit=1] store result score #wp mirror_wtmp2 run data get entity @s HurtTime
execute if score #wp mirror_wtmp2 matches 1.. as @e[tag=mirror_boss,distance=..4,sort=nearest,limit=1] run tag @s add wp_ranged_cand
scoreboard players set #wp mirror_wtmp2 0
execute as @e[tag=mirror_summon,distance=..4,sort=nearest,limit=1] store result score #wp mirror_wtmp2 run data get entity @s HurtTime
execute if score #wp mirror_wtmp2 matches 1.. as @e[tag=mirror_summon,distance=..4,sort=nearest,limit=1] run tag @s add wp_ranged_cand
