# 绘制队首残影：按入队维度/主人定位；用主人当前位置召一个同 tick 临时 marker 再设到 pos
# （直接 summon 在 0,0,0 可能落在未加载区块，导致粒子不生成）
# 注意顺序：先 at @s 把执行维度切到玩家，再 if dimension；否则 if dimension 检查的是 in 的维度。
execute store result score #can_owner mirror_zf_tmp2 run data get storage plm:mirror can_echo[0].owner
execute store result score #can_dim mirror_zf_tmp run data get storage plm:mirror can_echo[0].dim
execute as @a at @s if score @s player_uid = #can_owner mirror_zf_tmp2 if score #can_dim mirror_zf_tmp matches 0 if dimension minecraft:overworld run function plm:mirror/set/can/echo_draw_dim
execute as @a at @s if score @s player_uid = #can_owner mirror_zf_tmp2 if score #can_dim mirror_zf_tmp matches 1 if dimension minecraft:the_nether run function plm:mirror/set/can/echo_draw_dim
execute as @a at @s if score @s player_uid = #can_owner mirror_zf_tmp2 if score #can_dim mirror_zf_tmp matches 2 if dimension minecraft:the_end run function plm:mirror/set/can/echo_draw_dim
