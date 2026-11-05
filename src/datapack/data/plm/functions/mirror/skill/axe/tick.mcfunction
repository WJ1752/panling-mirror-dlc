# 裂影斧 · 5t tick（被动「影随」，设计 §2.2.3）
# 入口：plm:mirror/skill/tick 每 5t 调用一次。
#
# 实现口径：
# - 每 10t（#axe_buf 0/1 轮转，只递增一次）让每个斧玩家写一个每玩家独立的
#   6 点环形缓冲（记分板，不用全服 storage）。
# - 每 5t 对斧玩家 6 格内最近 12 只 tag=monster / tag=mirror_summon 检查是否落在
#   最近 2 个采样点的 1.5 格内；命中给 slowness I 1s（20t）。
# - 玩家必须按 dimension 过滤：@a 是全局选择器，但 @e 与粒子只认执行维度。
# - 距离判定用记分板平方和（坐标 ×100，1.5 格 = 150 → 平方 22500）。
# - 视觉：写点时就地铺黑色 dust，玩家移动时自然连成 6 点残影；旧点不重绘。

# ---- 10t 采样节流（5t × 2）；buffer 是全局量，只在 wrapper 里转 ----
scoreboard players add #axe_buf mirror_calc 1
execute if score #axe_buf mirror_calc matches 2.. run scoreboard players set #axe_buf mirror_calc 0
execute in minecraft:overworld if score #axe_buf mirror_calc matches 0 as @a[scores={mirror_form=1},tag=mirror_weapon_active] at @s if dimension minecraft:overworld run function plm:mirror/skill/axe/trail/append
execute in minecraft:the_nether if score #axe_buf mirror_calc matches 0 as @a[scores={mirror_form=1},tag=mirror_weapon_active] at @s if dimension minecraft:the_nether run function plm:mirror/skill/axe/trail/append
execute in minecraft:the_end if score #axe_buf mirror_calc matches 0 as @a[scores={mirror_form=1},tag=mirror_weapon_active] at @s if dimension minecraft:the_end run function plm:mirror/skill/axe/trail/append

# ---- 每 5t：6 格内最多 12 只敌人判定（按维度 + dimension 过滤）----
execute in minecraft:overworld as @a[scores={mirror_form=1},tag=mirror_weapon_active] at @s if dimension minecraft:overworld run function plm:mirror/skill/axe/trail/tick_player
execute in minecraft:the_nether as @a[scores={mirror_form=1},tag=mirror_weapon_active] at @s if dimension minecraft:the_nether run function plm:mirror/skill/axe/trail/tick_player
execute in minecraft:the_end as @a[scores={mirror_form=1},tag=mirror_weapon_active] at @s if dimension minecraft:the_end run function plm:mirror/skill/axe/trail/tick_player

# ---- 清理到期的 movement_speed 临时 modifier（按维度分别扫；只扫带本 tag 的实体）----
execute in minecraft:overworld run function plm:mirror/skill/axe/trail/unspeed
execute in minecraft:the_nether run function plm:mirror/skill/axe/trail/unspeed
execute in minecraft:the_end run function plm:mirror/skill/axe/trail/unspeed
