# 影随 · 换武器取消并返还 50% 冷却（@s=玩家）
# 设计 §2.4.2：取消记录并返还 50% 冷却；死亡取消不返还（见 cancel）。
function plm:mirror/skill/crossbow/yingsui/cancel
scoreboard players operation #half mirror_skill_tmp = @s mirror_yingsui_5ticks
scoreboard players operation #half mirror_skill_tmp /= #const2 mirror_calc
scoreboard players operation @s mirror_cd_a = #half mirror_skill_tmp
