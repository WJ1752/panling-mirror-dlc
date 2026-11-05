# 追加一条 DMG（上限 3）
# 近战/弓弩：11 条 active；炉形只有 ying_ren 有消费点（skill_hit），最多 1 条 DMG。
scoreboard players set #t wp_n_dmg 0
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[0] run scoreboard players add #t wp_n_dmg 1
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[1] run scoreboard players add #t wp_n_dmg 1
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[2] run scoreboard players add #t wp_n_dmg 1
execute if score #t wp_form matches 5..6 if score #t wp_n_dmg matches 1.. run return 0
execute if score #t wp_n_dmg matches 3.. run return 0
function plm:weapon/affix/pick_dmg
# 池里没有可用词条时 pick 会留下 wp_idx 0；此时不 roll/append，也不算“已加纹”。
execute if score #t wp_idx matches ..0 run return 0
function plm:weapon/affix/roll_val
function plm:weapon/affix/append/dmg
scoreboard players set #t wp_added 1
