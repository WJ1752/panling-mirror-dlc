# DMG 抽取一次尝试（镜隙 4 设计停用；其余 11 条均可抽，近战/弓弩/炉形共用）
scoreboard players add #t wp_attempt 1
function plm:weapon/util/rand100
scoreboard players operation #t wp_idx = #t wp_rand
scoreboard players operation #t wp_idx %= #sys wp_pool_dmg
scoreboard players add #t wp_idx 1
scoreboard players set #t wp_dup 0
execute if score #t wp_idx matches 1 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"po_xiao"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 2 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"xu_ying"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 3 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ni_lin"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 4 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"jing_xi"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 5 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"zhui_ying"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 6 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"lian_xing"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 7 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"bei_zhao"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 8 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"yu_xiang"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 9 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"ying_ren"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 10 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"su_feng"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 11 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"shuang_zhao"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 12 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[{id:"jing_shu"}] run scoreboard players set #t wp_dup 1

# 设计停用：镜隙(4) 不进入池；其余 11 条 DMG 均已实装。
execute if score #t wp_idx matches 4 run scoreboard players set #t wp_dup 1
# 炉形只有 ying_ren(9) 有消费点（plm:weapon/dmg/skill_hit）；其余 10 条对炉形是死词条，不进入池。
execute if score #t wp_form matches 5..6 unless score #t wp_idx matches 9 run scoreboard players set #t wp_dup 1
execute if score #t wp_dup matches 1 if score #t wp_attempt matches ..19 run function plm:weapon/affix/pick_dmg/try
execute if score #t wp_dup matches 1 if score #t wp_attempt matches 20.. run function plm:weapon/affix/pick_dmg/fallback
