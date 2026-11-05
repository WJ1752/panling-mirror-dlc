# FX 抽取一次尝试（10 条 FX 全部已实现并接线，按不重复抽取）
scoreboard players add #t wp_attempt 1
function plm:weapon/util/rand100
scoreboard players operation #t wp_idx = #t wp_rand
scoreboard players operation #t wp_idx %= #sys wp_pool_fx
scoreboard players add #t wp_idx 1
scoreboard players set #t wp_dup 0
execute if score #t wp_idx matches 1 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_hen"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 2 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"zhe_guang"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 3 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jie_ying"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 4 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"zhao_xi"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 5 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"shi_ying"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 6 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_xi"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 7 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"fan_zhao"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 8 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"shuang_ying"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 9 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"ying_sheng"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_idx matches 10 if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_jing"}] run scoreboard players set #t wp_dup 1
execute if score #t wp_dup matches 1 if score #t wp_attempt matches ..19 run function plm:weapon/affix/pick_fx/try
execute if score #t wp_dup matches 1 if score #t wp_attempt matches 20.. run function plm:weapon/affix/pick_fx/fallback
