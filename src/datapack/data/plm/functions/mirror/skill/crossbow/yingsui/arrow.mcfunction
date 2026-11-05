# 影随 · 在路径点生成 1 支齐射箭（@s=玩家）
# 箭本体不召唤残影实体；用 mirror_yingsui_arrow 做视觉/调试标记。
# 真实箭 damage=0，命中由 arrow/hit_check 对白名单目标直接结算；连影也在那里手动记账。
execute at @s run summon minecraft:arrow ~ ~1 ~ {Tags:["mirror_yingsui_arrow","mirror_shot_new"],pickup:2b,crit:0b,Motion:[0.0d,0.0d,0.0d]}
execute store result entity @e[tag=mirror_shot_new,limit=1] Pos[0] double 0.01 run scoreboard players get #cbpx mirror_wtmp
execute store result entity @e[tag=mirror_shot_new,limit=1] Pos[1] double 0.01 run scoreboard players get #cbpy mirror_wtmp2
execute store result entity @e[tag=mirror_shot_new,limit=1] Pos[2] double 0.01 run scoreboard players get #cbpz mirror_wtmp3
# Owner 记玩家：直接结算/归属反查
data modify entity @e[tag=mirror_shot_new,limit=1] Owner set from entity @s UUID
# 连影按 projectile_owner_uuid0..3 四项匹配；齐射箭不是玩家射出的，本体 set_shooter 不会给它写分，这里补写。
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid0 = @s player_uuid0
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid1 = @s player_uuid1
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid2 = @s player_uuid2
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid3 = @s player_uuid3

# 4 件套：齐射箭 30% 概率不衰减（直接结算时不按当前速度降低伤害）
execute if score @s mirror_crossbow_4_until >= #sys mirror_game_time run function plm:mirror/skill/crossbow/yingsui/no_falloff

# 每个点独立找 8 格内最近敌人（以箭所在点为圆心）
# 白名单：monster / mirror_boss / mirror_summon（CONTRACT §4）
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
execute at @e[tag=mirror_shot_new,limit=1] run tag @e[tag=monster,distance=..8,sort=nearest,limit=1] add mirror_dmg_target
execute at @e[tag=mirror_shot_new,limit=1] unless entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_boss,distance=..8,sort=nearest,limit=1] add mirror_dmg_target
execute at @e[tag=mirror_shot_new,limit=1] unless entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_summon,distance=..8,sort=nearest,limit=1] add mirror_dmg_target
execute unless entity @e[tag=mirror_dmg_target,limit=1] run kill @e[tag=mirror_shot_new]
execute unless entity @e[tag=mirror_dmg_target,limit=1] run return 0

# 残影视觉
execute at @e[tag=mirror_shot_new,limit=1] run particle minecraft:dust 0.55 0.25 0.95 1.0 ~ ~ ~ 0.35 0.8 0.35 0 8
function plm:mirror/skill/crossbow/shot/aim
# 本次影随实际射出的箭数（测试/后续特效可读；箭命中后实体消失，不能靠箭实体计数）
scoreboard players add @s mirror_yingsui_fired 1
tag @e[tag=mirror_shot_new] remove mirror_shot_new
# aim 只借用 mirror_dmg_target 找目标；这里不结算，用完立刻清
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
# 1t 直接结算循环：只在有技能箭时运行，无箭自停
schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
