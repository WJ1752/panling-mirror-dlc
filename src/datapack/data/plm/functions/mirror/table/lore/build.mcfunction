# 在 storage plm:tbl lore_item 上按 tag 重建防具 display.Lore
# 输入：lore_item.tag.mirror_degree / mirror_lock / mirror_line1..3
# 输出：写回同路径；调用方负责把 lore_item 写回方块槽位
data modify storage plm:tbl lore_item.tag.display.Lore set value []

# 固定两行（与输出模板一致）
data modify storage plm:tbl lore_item.tag.display.Lore append value '{"translate":"pl.lore.rare7"}'
data modify storage plm:tbl lore_item.tag.display.Lore append value '{"translate":"pl.lore.limit3"}'

# 读映度/锁位数/三条镜律（用 #t mirror_* 专用 scratch，避免覆盖 roll 的 #t law1..3）
scoreboard players set #t mirror_degree 0
execute store result score #t mirror_degree run data get storage plm:tbl lore_item.tag.mirror_degree
scoreboard players set #t mirror_lock 0
execute store result score #t mirror_lock run data get storage plm:tbl lore_item.tag.mirror_lock
scoreboard players set #t mirror_line1 0
execute store result score #t mirror_line1 run data get storage plm:tbl lore_item.tag.mirror_line1
scoreboard players set #t mirror_line2 0
execute store result score #t mirror_line2 run data get storage plm:tbl lore_item.tag.mirror_line2
scoreboard players set #t mirror_line3 0
execute store result score #t mirror_line3 run data get storage plm:tbl lore_item.tag.mirror_line3

# 映度星数（0..5）
execute if score #t mirror_degree matches 0 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f映度：§7※※※※※"}'
execute if score #t mirror_degree matches 1 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f映度：§b★§7※※※※"}'
execute if score #t mirror_degree matches 2 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f映度：§b★★§7※※※"}'
execute if score #t mirror_degree matches 3 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f映度：§b★★★§7※※"}'
execute if score #t mirror_degree matches 4 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f映度：§b★★★★§7※"}'
execute if score #t mirror_degree matches 5 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f映度：§b★★★★★"}'
execute if score #t mirror_degree matches 5 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§d本件映度已满；四件全 5 时激活真影律"}'

# 镜律
data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§8===== §f§l【镜律】§8====="}'
execute if score #t mirror_line1 matches 0 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"translate":"pl.lore.mirror_no_line"}'
execute if score #t mirror_line1 matches 1.. run function plm:mirror/table/lore/line1
execute if score #t mirror_line2 matches 0 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§7∟② 未解锁（定影符·贰）"}'
execute if score #t mirror_line2 matches 1.. run function plm:mirror/table/lore/line2
execute if score #t mirror_line3 matches 0 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§7∟③ 未解锁（定影符·叁）"}'
execute if score #t mirror_line3 matches 1.. run function plm:mirror/table/lore/line3

# 定影状态
execute if score #t mirror_lock matches 0 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f定影：§7未定影（磨镜可重抽）"}'
execute if score #t mirror_lock matches 1 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f定影：§b1 §7/ 3（第 1 条已锁）"}'
execute if score #t mirror_lock matches 2 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f定影：§b2 §7/ 3（前 2 条已锁）"}'
execute if score #t mirror_lock matches 3 run data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§f定影：§b3 §7/ 3（三条全锁）"}'

# 旧防具线状态（数值效果尚未接入战斗）
data modify storage plm:tbl lore_item.tag.display.Lore append value '{"text":"§8旧镜装：镜律/映度数值效果尚未实装"}'
