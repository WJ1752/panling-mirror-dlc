# 留影 · 5t 生命周期（所有维度一次性处理）
# 1) 主人死亡 / 离线 / 换维度：清除（mark_owner 只匹配同一维度的主人）
# 2) 寿命倒计时，到期消散
# 3) 攻击间隔倒计时，到点射击
# 注意：`execute in <dim>` 在 schedule/console 源下不会把 @e 限制在目标维度；
# 逐维度调用会把同一台弩机按 3 倍递减寿命/攻击间隔。这里只跑一次，靠 at @s 定位。
tag @e[tag=mirror_turret] remove mirror_turret_alive
execute as @a at @s run function plm:mirror/skill/crossbow/liuying/mark_owner
execute as @e[tag=mirror_turret,tag=!mirror_turret_alive] at @s run function plm:mirror/skill/crossbow/liuying/end

scoreboard players remove @e[tag=mirror_turret] mirror_turret_5ticks 1
execute as @e[tag=mirror_turret,scores={mirror_turret_5ticks=..0}] at @s run function plm:mirror/skill/crossbow/liuying/end

scoreboard players remove @e[tag=mirror_turret] mirror_turret_interval 1
execute as @e[tag=mirror_turret,scores={mirror_turret_interval=..0}] at @s run function plm:mirror/skill/crossbow/liuying/fire
