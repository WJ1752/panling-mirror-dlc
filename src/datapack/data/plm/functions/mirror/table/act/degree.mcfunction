# ---- 映度：槽3 镜装（防具；is_armor:1 防止 v1 旧镜武落到旧表） + 槽0 倒影核×N + 槽8 影尘×10 ----
# 旧镜武（mirror:1 但非防具）+ 倒影核：明确拒绝并停表，避免继续落到分解
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run tellraw @s {"text":"[磨镜台] 旧镜武不能提升映度，请改用武器台或直接分解。","color":"red"}
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t diff 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run return 0
execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] run return 0
execute unless data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run return 0
execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0

# 当前映度必须 < 5
execute store result score #t deg run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_degree
execute if score #t deg matches 5.. run return 0

# 需要的倒影核数 = 当前映度 + 1
scoreboard players operation #t need = #t deg
scoreboard players add #t need 1
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count
scoreboard players operation #t left = #t count
scoreboard players operation #t left -= #t need
execute if score #t left matches ..-1 run return 0

# 影尘 ≥10
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count
execute if score #t count matches ..9 run return 0

# 升映度
scoreboard players add #t deg 1
function plm:mirror/table/write_degree

# 映度变化后重写 Lore（星数与真影律提示）
function plm:mirror/table/lore/refresh

# 扣倒影核（精确扣 N 个）
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:0b}].Count
scoreboard players operation #t left = #t count
scoreboard players operation #t left -= #t need
execute if score #t left matches 1.. run function plm:mirror/table/write_core_left
execute if score #t left matches ..0 run data remove block ~ ~ ~ Items[{Slot:0b}]

# 扣影尘 10
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count
scoreboard players remove #t count 10
execute if score #t count matches 1.. run function plm:mirror/table/write_dust_left
execute if score #t count matches ..0 run data remove block ~ ~ ~ Items[{Slot:8b}]

# 回输出位
item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3
data remove block ~ ~ ~ Items[{Slot:3b}]

scoreboard players set #t success 1
tellraw @s {"text":"[磨镜台] 映度提升——镜律数值随映度增强。","color":"aqua"}
