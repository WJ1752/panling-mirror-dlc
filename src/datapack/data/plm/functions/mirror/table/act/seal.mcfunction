# ---- 定影：槽3 镜装 + 槽1 定影符(壹/贰/叁) + 槽8 影尘×10 ----
# 旧镜武（mirror:1 但非防具）+ 定影符：明确拒绝并停表，避免继续落到分解
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t diff 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t diff 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t diff 1
execute if score #t diff matches 1 run tellraw @s {"text":"[磨镜台] 旧镜武不能定影，请改用武器台或直接分解。","color":"red"}
execute if score #t diff matches 1 run return 0
execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] run return 0
# 必须有定影符
scoreboard players set #t seal_lvl 0
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t seal_lvl 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t seal_lvl 2
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t seal_lvl 3
execute if score #t seal_lvl matches 0 run return 0

# 影尘 ≥10
execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run return 0
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count
execute unless score #t count matches 10.. run return 0

# 当前锁位数必须等于 符等级-1（壹锁第1条、贰锁第2条、叁锁第3条）
execute store result score #t lock run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_lock
scoreboard players operation #t need = #t seal_lvl
scoreboard players remove #t need 1
execute unless score #t lock = #t need run return 0

# 未磨镜的新防具没有 mirror_lastN：必须拒绝，不能 set from 静默失败后照样写锁/扣材料
scoreboard players set #t tmp2 0
execute if score #t seal_lvl matches 1 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last1 run scoreboard players set #t tmp2 1
execute if score #t seal_lvl matches 2 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last2 run scoreboard players set #t tmp2 1
execute if score #t seal_lvl matches 3 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last3 run scoreboard players set #t tmp2 1
execute unless score #t tmp2 matches 1 run tellraw @s {"text":"[磨镜台] 没有可定影的镜律，请先磨镜。","color":"red"}
execute unless score #t tmp2 matches 1 run scoreboard players set #t diff 1
execute unless score #t tmp2 matches 1 run return 0

# 定影候选必须是 1..24；0/缺失都不合法
scoreboard players set #t tmp 0
execute if score #t seal_lvl matches 1 store result score #t tmp run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last1
execute if score #t seal_lvl matches 2 store result score #t tmp run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last2
execute if score #t seal_lvl matches 3 store result score #t tmp run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last3
execute unless score #t tmp matches 1..24 run tellraw @s {"text":"[磨镜台] 定影候选无效，请重新磨镜。","color":"red"}
execute unless score #t tmp matches 1..24 run scoreboard players set #t diff 1
execute unless score #t tmp matches 1..24 run return 0

# 定影第 2/3 条前，已锁的前序镜律必须真实有效（防止旧档/异常物品带着 lock 但 line=0）
scoreboard players set #t tmp2 1
scoreboard players set #t tmp 0
execute if score #t seal_lvl matches 2 store result score #t tmp run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1
execute if score #t seal_lvl matches 2 unless score #t tmp matches 1..24 run scoreboard players set #t tmp2 0
scoreboard players set #t tmp 0
execute if score #t seal_lvl matches 3 store result score #t tmp run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1
execute if score #t seal_lvl matches 3 unless score #t tmp matches 1..24 run scoreboard players set #t tmp2 0
scoreboard players set #t tmp 0
execute if score #t seal_lvl matches 3 store result score #t tmp run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line2
execute if score #t seal_lvl matches 3 unless score #t tmp matches 1..24 run scoreboard players set #t tmp2 0
execute if score #t tmp2 matches 0 run tellraw @s {"text":"[磨镜台] 前序镜律未定影或无效，无法继续定影。","color":"red"}
execute if score #t tmp2 matches 0 run scoreboard players set #t diff 1
execute if score #t tmp2 matches 0 run return 0

# 把 mirror_lastN 固化为 mirror_lineN
execute if score #t seal_lvl matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line1 set from block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last1
execute if score #t seal_lvl matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line2 set from block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last2
execute if score #t seal_lvl matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_line3 set from block ~ ~ ~ Items[{Slot:3b}].tag.mirror_last3
function plm:mirror/table/write_lock

# 按当前 mirror_degree / mirror_lock / mirror_line1..3 重写 Lore（定影后镜律行立即生效）
function plm:mirror/table/lore/refresh

# 扣材料：定影符 1 个（写回 count-1，不能整堆删除）、影尘 10 个（写回余量）
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:1b}].Count
scoreboard players remove #t count 1
execute if score #t count matches 1.. run function plm:mirror/table/write_seal_left
execute if score #t count matches ..0 run data remove block ~ ~ ~ Items[{Slot:1b}]
execute store result score #t count run data get block ~ ~ ~ Items[{Slot:8b}].Count
scoreboard players remove #t count 10
execute if score #t count matches 1.. run function plm:mirror/table/write_dust_left
execute if score #t count matches ..0 run data remove block ~ ~ ~ Items[{Slot:8b}]

# 回输出位
item replace block ~ ~ ~ container.5 from block ~ ~ ~ container.3
data remove block ~ ~ ~ Items[{Slot:3b}]

scoreboard players set #t success 1
tellraw @s {"text":"[磨镜台] 定影成功——这条镜律从此不再改变。","color":"aqua"}
