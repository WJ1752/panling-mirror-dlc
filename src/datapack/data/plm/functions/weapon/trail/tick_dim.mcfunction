# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 每 5t：有效的 trail 点对 1.5 格内敌人施加减速；过期的减速修饰符清理。
# 服务器来源的 @e 无 distance 时会跨维度选择，所有选择器都带 distance 限定本维度。
execute as @e[type=minecraft:marker,tag=plm_trail_0,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply
execute as @e[type=minecraft:marker,tag=plm_trail_1,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply
execute as @e[type=minecraft:marker,tag=plm_trail_2,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply
execute as @e[type=minecraft:marker,tag=plm_trail_3,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply
execute as @e[type=minecraft:marker,tag=plm_trail_4,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply
execute as @e[type=minecraft:marker,tag=plm_trail_5,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply
execute as @e[tag=plm_trail_slow,distance=..30000000] if score @s mirror_trail_slow_until <= #sys mirror_game_time run function plm:weapon/fx/jing_jing/unspeed
