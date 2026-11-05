# 顶掉最旧：剩余寿命 mirror_turret_5ticks 最小的那台
# @s=玩家；调用前 owner 的弩机已打 mirror_turret_mine。
tag @e[tag=mirror_turret_mine] remove mirror_turret_old
scoreboard players set #old mirror_wtmp10 999
execute as @e[tag=mirror_turret_mine] run function plm:mirror/skill/crossbow/liuying/pick_oldest
kill @e[tag=mirror_turret_old]
