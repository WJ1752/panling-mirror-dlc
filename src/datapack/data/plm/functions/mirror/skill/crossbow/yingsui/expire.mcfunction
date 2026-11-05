# 影随 · path_t 归零（@s=玩家，at @s）
# path_n 是“已记录点数”：被 clear/abort 清成 0 时不再齐射，只清状态（防换维度后拿旧路径开火）。
execute unless score @s mirror_path_n matches 1.. run function plm:mirror/skill/crossbow/yingsui/cancel
execute if score @s mirror_path_n matches 1.. run function plm:mirror/skill/crossbow/yingsui/fire
