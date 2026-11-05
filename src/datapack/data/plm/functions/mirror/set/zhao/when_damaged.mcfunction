# 照心受击：@s=玩家。
# 1) 有镜心时按快照把“每层 4% 减伤”折算成治疗债务（zhao/apply_damage + debt）。
# 2) 每次受击叠 1 层镜心（§4.6 “受击/击杀叠层”口径）；同一 tick 去重，2 件套才生效。
# 依赖 zhao/snapshot 记录的受击前 Health（mirror_shatter_target）。
# 引擎限制：1.20.1 没有受伤倍率/分数治疗，所以这不是逐击精确 4%：致命一击救不回；
# Absorption 期间 Health 不变，伤害无法计算（但受击事件仍会叠层）。
# 死亡：shared clear 未清镜心，这里在致死受击时自行清理（不改共享 clear）。
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_heart 0
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_heart_until 0
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_shatter 0
execute if data entity @s {Health:0.0f} run scoreboard players set @s mirror_shatter_target 0
execute if data entity @s {Health:0.0f} run return 0

# 上限为 0 说明照心件不足（或尚未计算）：不叠层、不减伤
function plm:mirror/set/zhao/max
execute if score @s mirror_heart_max matches ..0 run return 0
# 过期先清，再判断本次是否吃减伤
execute if score @s mirror_heart matches 1.. if score @s mirror_heart_until <= #sys mirror_game_time run scoreboard players set @s mirror_heart 0

# 有层数才结算减伤；0 层的第一次受击只负责把快照更新到当前血量
execute if score @s mirror_heart matches 1.. run function plm:mirror/set/zhao/apply_damage
# 没有 apply_damage 时也要刷新快照，避免下一次受击把旧血量差算成伤害
execute store result score @s mirror_shatter_target run data get entity @s Health 100

# 受击叠 1 层（heart_add 内有同 tick 去重；满层/碎镜逻辑不变）
function plm:mirror/set/zhao/heart_add
