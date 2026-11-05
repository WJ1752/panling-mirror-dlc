# ---- 磨镜：槽3 必须是镜装（防具；is_armor:1 防止 v1 旧镜武落到旧表） ----
# 旧镜武（mirror:1 但非防具）+ 砺镜砂：明确拒绝并停表，避免继续落到分解把旧镜武吃掉
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run tellraw @s {"text":"[磨镜台] 旧镜武不能磨镜，请改用武器台或直接分解。","color":"red"}
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t diff 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run return 0
execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] run return 0
# 槽0 必须是砺镜砂
execute unless data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run return 0
# 影尘 ≥10
execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count
execute unless score #t count matches 10.. run return 0

# 读当前锁位数
execute store result score #t lock run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_lock

# 三条全锁 = 已定型：拒绝，不掷骰、不扣材料
execute if score #t lock matches 3.. run tellraw @s {"text":"[磨镜台] 三条镜律已全部定影，无法再磨。","color":"red"}
execute if score #t lock matches 3.. run scoreboard players set #t diff 1
execute if score #t lock matches 3.. run return 0

# 掷骰：用 loot table 抽 3 条镜律（不重复，且排除已定影镜律），结果暂存到 #t law1..3
function plm:mirror/table/roll

# 写入全部未锁槽位（lock 0=写 1/2/3；lock 1=写 2/3；lock 2=写 3）
execute if score #t lock matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1 set value 0
execute if score #t lock matches 0 run function plm:mirror/table/write_line1
execute if score #t lock matches 1.. run function plm:mirror/table/write_line2
execute if score #t lock matches 2.. run function plm:mirror/table/write_line3

# 记录本次结果（供定影选择）
function plm:mirror/table/write_last1
function plm:mirror/table/write_last2
function plm:mirror/table/write_last3

# 按当前 mirror_degree / mirror_lock / mirror_line1..3 重写 Lore（镜律名称与映度星数）
function plm:mirror/table/lore/refresh

# 扣材料：砺镜砂 1 个（写回 count-1，不能整堆删除）、影尘 10 个（写回余量）
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count
scoreboard players remove #t count 1
scoreboard players operation #t left = #t count
execute if score #t count matches 1.. run function plm:mirror/table/write_core_left
execute if score #t count matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count
scoreboard players remove #t count 10
execute if score #t count matches 1.. run function plm:mirror/table/write_dust_left
execute if score #t count matches ..0 run data remove block ~ ~ ~ Items[{Slot:8b}]

# 播报/报告用最终落在物品上的三行（已锁行保持旧值，不能用本次候选 law1..3 冒充）
execute store result score #t law1 run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1
execute store result score #t law2 run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line2
execute store result score #t law3 run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line3

# 把结果放回输出位（玩家取回）
item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3
data remove block ~ ~ ~ Items[{Slot:3b}]

scoreboard players set #t success 1
tellraw @s {"text":"[磨镜台] 镜面一转——新的镜律已映出，请取回装备。","color":"aqua"}
function plm:mirror/table/report_lines
