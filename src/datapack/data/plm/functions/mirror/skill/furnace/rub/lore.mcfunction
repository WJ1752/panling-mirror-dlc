# 拓印镜炉 Lore「印：N/3 · 类型」（@s = 玩家）
# 只在主手/副手确实持有 act:1 的拓印镜炉时改写，绝不碰其他物品。
# 调用点：rub/tick_dim 每 5t 同步一次（覆盖加印/放印/死亡 clear 后的分数变化）。
# Lore 末行是 weapon/table/lore 预留的“本行留空”占位行；这里覆盖它。
# 没有 Lore 的旧物品/开发物品走 lore_init，建一个单行 Lore 列表。
# 玩家 NBT 不能用 /data modify 写（1.20.1 会拒绝 player data），所以用 /item modify。
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0

# 只在 印数 / 类型 / 上限 变化时重建 Lore（每 5t 的静态字符串写入很贵）。
# 签名 = stack*100 + type*10 + max；mirror_rub_award 在玩家身上专用于这个缓存。
scoreboard players operation #sig mirror_rub_cd = @s mirror_rub_stack
scoreboard players operation #sig mirror_rub_cd *= #const100 mirror_calc
scoreboard players operation #tmp mirror_rub_extra = @s mirror_rub_type
scoreboard players operation #tmp mirror_rub_extra *= #const10 mirror_calc
scoreboard players operation #sig mirror_rub_cd += #tmp mirror_rub_extra
scoreboard players operation #sig mirror_rub_cd += @s mirror_rub_max
execute if score @s mirror_rub_award = #sig mirror_rub_cd run return 0
scoreboard players operation @s mirror_rub_award = #sig mirror_rub_cd

# 先把本玩家的显示行写进 storage（5 类型 × 0..5 印数），再派生成单元素列表
function plm:mirror/skill/furnace/rub/lore/build
data modify storage plm:rub lore_list set value []
data modify storage plm:rub lore_list append from storage plm:rub lore

execute if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] run function plm:mirror/skill/furnace/rub/lore/main
execute if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run function plm:mirror/skill/furnace/rub/lore/off
