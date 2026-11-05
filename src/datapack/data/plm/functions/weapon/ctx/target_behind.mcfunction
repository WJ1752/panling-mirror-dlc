# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 输出 #wp mirror_wtmp10 = 1 表示「攻击者位于目标的水平背后 120° 锥内」（设计 §6.1 背照）。
# 参考系是目标：origin=目标位置，facing=目标朝向；比较 facing 与 (玩家-目标) 的夹角。
# 条件等价于 dot<0 且 cos<-0.5：4*dot^2 > |f|^2*dist^2；坐标用 0.1 格定点（scale 10），忽略 Y。
scoreboard players set #wp mirror_wtmp10 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
kill @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64]
# 在目标前方 1 格（水平）放 marker：用目标的 yaw，pitch 归零。
execute at @e[tag=plm_ctx_target,limit=1] rotated as @e[tag=plm_ctx_target,limit=1] rotated ~ 0 run summon minecraft:marker ~ ~ ~ {Tags:["plm_weapon_calc"]}
execute at @e[tag=plm_ctx_target,limit=1] rotated as @e[tag=plm_ctx_target,limit=1] rotated ~ 0 run tp @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64,limit=1] ^ ^ ^1

# 原点 = 目标坐标
execute store result score #wp mirror_wtmp2 run data get entity @e[tag=plm_ctx_target,limit=1] Pos[0] 10
execute store result score #wp mirror_wtmp3 run data get entity @e[tag=plm_ctx_target,limit=1] Pos[2] 10
# 目标前方向量 = marker - 目标
execute store result score #wp mirror_wtmp4 run data get entity @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64,limit=1] Pos[0] 10
execute store result score #wp mirror_wtmp5 run data get entity @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64,limit=1] Pos[2] 10
scoreboard players operation #wp mirror_wtmp4 -= #wp mirror_wtmp2
scoreboard players operation #wp mirror_wtmp5 -= #wp mirror_wtmp3
kill @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64]

# 玩家相对目标的向量
execute store result score #wp mirror_wtmp6 run data get entity @s Pos[0] 10
execute store result score #wp mirror_wtmp7 run data get entity @s Pos[2] 10
scoreboard players operation #wp mirror_wtmp6 -= #wp mirror_wtmp2
scoreboard players operation #wp mirror_wtmp7 -= #wp mirror_wtmp3

# dot = fx*dx + fz*dz
scoreboard players operation #wp mirror_wtmp = #wp mirror_wtmp4
scoreboard players operation #wp mirror_wtmp *= #wp mirror_wtmp6
scoreboard players operation #wp mirror_wtmp8 = #wp mirror_wtmp5
scoreboard players operation #wp mirror_wtmp8 *= #wp mirror_wtmp7
scoreboard players operation #wp mirror_wtmp += #wp mirror_wtmp8

# dist2 = dx*dx + dz*dz
scoreboard players operation #wp mirror_wtmp8 = #wp mirror_wtmp6
scoreboard players operation #wp mirror_wtmp8 *= #wp mirror_wtmp6
scoreboard players operation #wp mirror_wtmp9 = #wp mirror_wtmp7
scoreboard players operation #wp mirror_wtmp9 *= #wp mirror_wtmp7
scoreboard players operation #wp mirror_wtmp8 += #wp mirror_wtmp9

# 条件：dot<0 且 4*dot^2 > |f|^2 * dist2 = 100 * dist2（|f|=10）
execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp11 = #wp mirror_wtmp
execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp11 *= #wp mirror_wtmp
execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp11 *= #const4 mirror_calc
execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp8 *= #const100 mirror_calc
execute if score #wp mirror_wtmp matches ..-1 if score #wp mirror_wtmp11 > #wp mirror_wtmp8 run scoreboard players set #wp mirror_wtmp10 1
kill @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64]
