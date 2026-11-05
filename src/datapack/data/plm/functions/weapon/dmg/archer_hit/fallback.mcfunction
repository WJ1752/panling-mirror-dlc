# 箭实体已消失时的目标回退：@s=射手。
# 用 ctx/arrow 存在射手身上的最近一箭快照 + 玩家 48 格内刚受伤（HurtTime>0）的白名单目标。
# 48 格是普通弓的实战射程上限；更远时没有受害者信息可用，直接不结算（不猜目标）。
# 不清 mirror_last_ranged_until：这个分数属于 ctx/arrow → mirror/ranged/fallback 的共享回退窗口，
# 在本函数里清零会让 mirror 侧真正的命中回退失效。
tag @e[tag=wp_ranged_cand] remove wp_ranged_cand
scoreboard players set #wp mirror_wtmp2 0
execute as @e[tag=monster,distance=..48,sort=nearest,limit=1] store result score #wp mirror_wtmp2 run data get entity @s HurtTime
execute if score #wp mirror_wtmp2 matches 1.. as @e[tag=monster,distance=..48,sort=nearest,limit=1] run tag @s add wp_ranged_cand
scoreboard players set #wp mirror_wtmp2 0
execute as @e[tag=mirror_boss,distance=..48,sort=nearest,limit=1] store result score #wp mirror_wtmp2 run data get entity @s HurtTime
execute if score #wp mirror_wtmp2 matches 1.. as @e[tag=mirror_boss,distance=..48,sort=nearest,limit=1] run tag @s add wp_ranged_cand
scoreboard players set #wp mirror_wtmp2 0
execute as @e[tag=mirror_summon,distance=..48,sort=nearest,limit=1] store result score #wp mirror_wtmp2 run data get entity @s HurtTime
execute if score #wp mirror_wtmp2 matches 1.. as @e[tag=mirror_summon,distance=..48,sort=nearest,limit=1] run tag @s add wp_ranged_cand
