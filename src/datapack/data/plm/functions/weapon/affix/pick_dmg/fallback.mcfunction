# DMG 兜底：近战/弓弩 11 条 active；炉形只有 ying_ren(9) 有消费点（skill_hit）
# 镜隙(4) 设计停用，不在任何池中。按顺序找第一个未用，没有则 wp_idx=0
scoreboard players set #t wp_found 0
scoreboard players set #t wp_idx 0
# 炉形（form 5..6）：只兜底 ying_ren
execute if score #t wp_form matches 5..6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ying_ren"}] run scoreboard players set #t wp_idx 9
execute if score #t wp_form matches 5..6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ying_ren"}] run scoreboard players set #t wp_found 1
# 近战/弓弩（form 1..4）：11 条 active
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"po_xiao"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"po_xiao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"xu_ying"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"xu_ying"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ni_lin"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ni_lin"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"zhui_ying"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"zhui_ying"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"lian_xing"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"lian_xing"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"bei_zhao"}] run scoreboard players set #t wp_idx 7
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"bei_zhao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"yu_xiang"}] run scoreboard players set #t wp_idx 8
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"yu_xiang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ying_ren"}] run scoreboard players set #t wp_idx 9
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ying_ren"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"su_feng"}] run scoreboard players set #t wp_idx 10
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"su_feng"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"shuang_zhao"}] run scoreboard players set #t wp_idx 11
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"shuang_zhao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"jing_shu"}] run scoreboard players set #t wp_idx 12
execute if score #t wp_form matches 1..4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"jing_shu"}] run scoreboard players set #t wp_found 1
