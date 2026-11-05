# 镜花弓单维度 5t：只扫带 mirror_bloom_arrow 的箭。
# 不做花影的全局过期 tick（过期在 route / resolve 触发点清）。

# ---- 箭上 15s 保险 ----
execute as @e[type=arrow,tag=mirror_bloom_arrow,scores={mirror_bloom_5ticks=1..}] run scoreboard players remove @s mirror_bloom_5ticks 1
# 到期：摘 tag 并 reset 逐箭记分板（review #25），避免箭实体消失后 UUID 条目永久累积
execute as @e[type=arrow,tag=mirror_bloom_arrow,scores={mirror_bloom_5ticks=..0}] run function plm:mirror/skill/bow/reset_arrow

# ---- 落地：打方块也绽放（8 格内有敌）或只放镜面（无敌人） ----
execute as @e[type=arrow,tag=mirror_bloom_arrow,nbt={inGround:1b}] at @s run function plm:mirror/skill/bow/block_hit

# ---- 飞行中的青色镜光 ----
execute as @e[type=arrow,tag=mirror_bloom_arrow,nbt={inGround:0b}] at @s run particle minecraft:dust 0.45 0.9 1 1 ~ ~ ~ 0.03 0.03 0.03 0.01 2
