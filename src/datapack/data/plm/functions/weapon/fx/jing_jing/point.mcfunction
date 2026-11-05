# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 轮转 6 个 trail marker，把当前点放到 @s 脚下并设置 40t 有效。
# 服务器来源的 @e 无 distance 时会跨维度选择，因此所有 marker 选择器都带 distance；
# 若玩家维度/区块里没有可选的 marker（跨维度或预生成点在未加载区块），就地补一个。
execute if score #sys mirror_trail_next matches 0 unless entity @e[type=minecraft:marker,tag=plm_trail_0,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_0"]}
execute if score #sys mirror_trail_next matches 0 run tp @e[type=minecraft:marker,tag=plm_trail_0,limit=1] ~ ~ ~
execute if score #sys mirror_trail_next matches 0 run scoreboard players operation @e[type=minecraft:marker,tag=plm_trail_0,limit=1] mirror_trail_until = #sys mirror_game_time
execute if score #sys mirror_trail_next matches 0 run scoreboard players add @e[type=minecraft:marker,tag=plm_trail_0,limit=1] mirror_trail_until 40
execute if score #sys mirror_trail_next matches 1 unless entity @e[type=minecraft:marker,tag=plm_trail_1,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_1"]}
execute if score #sys mirror_trail_next matches 1 run tp @e[type=minecraft:marker,tag=plm_trail_1,limit=1] ~ ~ ~
execute if score #sys mirror_trail_next matches 1 run scoreboard players operation @e[type=minecraft:marker,tag=plm_trail_1,limit=1] mirror_trail_until = #sys mirror_game_time
execute if score #sys mirror_trail_next matches 1 run scoreboard players add @e[type=minecraft:marker,tag=plm_trail_1,limit=1] mirror_trail_until 40
execute if score #sys mirror_trail_next matches 2 unless entity @e[type=minecraft:marker,tag=plm_trail_2,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_2"]}
execute if score #sys mirror_trail_next matches 2 run tp @e[type=minecraft:marker,tag=plm_trail_2,limit=1] ~ ~ ~
execute if score #sys mirror_trail_next matches 2 run scoreboard players operation @e[type=minecraft:marker,tag=plm_trail_2,limit=1] mirror_trail_until = #sys mirror_game_time
execute if score #sys mirror_trail_next matches 2 run scoreboard players add @e[type=minecraft:marker,tag=plm_trail_2,limit=1] mirror_trail_until 40
execute if score #sys mirror_trail_next matches 3 unless entity @e[type=minecraft:marker,tag=plm_trail_3,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_3"]}
execute if score #sys mirror_trail_next matches 3 run tp @e[type=minecraft:marker,tag=plm_trail_3,limit=1] ~ ~ ~
execute if score #sys mirror_trail_next matches 3 run scoreboard players operation @e[type=minecraft:marker,tag=plm_trail_3,limit=1] mirror_trail_until = #sys mirror_game_time
execute if score #sys mirror_trail_next matches 3 run scoreboard players add @e[type=minecraft:marker,tag=plm_trail_3,limit=1] mirror_trail_until 40
execute if score #sys mirror_trail_next matches 4 unless entity @e[type=minecraft:marker,tag=plm_trail_4,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_4"]}
execute if score #sys mirror_trail_next matches 4 run tp @e[type=minecraft:marker,tag=plm_trail_4,limit=1] ~ ~ ~
execute if score #sys mirror_trail_next matches 4 run scoreboard players operation @e[type=minecraft:marker,tag=plm_trail_4,limit=1] mirror_trail_until = #sys mirror_game_time
execute if score #sys mirror_trail_next matches 4 run scoreboard players add @e[type=minecraft:marker,tag=plm_trail_4,limit=1] mirror_trail_until 40
execute if score #sys mirror_trail_next matches 5 unless entity @e[type=minecraft:marker,tag=plm_trail_5,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_5"]}
execute if score #sys mirror_trail_next matches 5 run tp @e[type=minecraft:marker,tag=plm_trail_5,limit=1] ~ ~ ~
execute if score #sys mirror_trail_next matches 5 run scoreboard players operation @e[type=minecraft:marker,tag=plm_trail_5,limit=1] mirror_trail_until = #sys mirror_game_time
execute if score #sys mirror_trail_next matches 5 run scoreboard players add @e[type=minecraft:marker,tag=plm_trail_5,limit=1] mirror_trail_until 40
scoreboard players add #sys mirror_trail_next 1
scoreboard players operation #sys mirror_trail_next %= #const6 mirror_calc
