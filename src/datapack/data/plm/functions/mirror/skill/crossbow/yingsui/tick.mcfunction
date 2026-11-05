# 影随 · 5s 记录/到期（@s=玩家，at @s）
# 死亡由 plm:tick/main 的 clear 统一处理（mirror_death）；换维度由 changed_dimension
# advancement clear；这里再做维度防御和换武器取消返还。
# 死亡：clear 通常已先处理；再加一层，确保不会走 cancel_refund 返还 50%。
execute if score @s mirror_death matches 1.. run function plm:mirror/skill/crossbow/yingsui/cancel
execute unless entity @s[tag=mirror_yingsui_rec] run return 0

# 防御：施放维度和当前维度不一致 → 取消（不返还，视为路径作废）
execute if score @s mirror_path_dim matches 0 unless dimension minecraft:overworld run function plm:mirror/skill/crossbow/yingsui/cancel
execute if score @s mirror_path_dim matches 1 unless dimension minecraft:the_nether run function plm:mirror/skill/crossbow/yingsui/cancel
execute if score @s mirror_path_dim matches 2 unless dimension minecraft:the_end run function plm:mirror/skill/crossbow/yingsui/cancel
execute unless entity @s[tag=mirror_yingsui_rec] run return 0

# 换武器（不是死亡）：取消并返还 50% 冷却
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run function plm:mirror/skill/crossbow/yingsui/cancel_refund
execute unless entity @s[tag=mirror_yingsui_rec] run return 0

# 先记录再递减：path_t=100,95,...；只有 %10==0 时落点 -> 10 个点
execute if score @s mirror_path_t matches 1.. run function plm:mirror/skill/crossbow/yingsui/record
execute if score @s mirror_path_t matches 1.. run scoreboard players remove @s mirror_path_t 5
execute if score @s mirror_path_t matches ..0 run function plm:mirror/skill/crossbow/yingsui/expire
