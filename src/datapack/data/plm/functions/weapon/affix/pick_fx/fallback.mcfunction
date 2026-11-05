# FX 兜底：10 条 FX 全部已实现；按顺序找第一个未用，10 条全用则 wp_idx=0
scoreboard players set #t wp_found 0
scoreboard players set #t wp_idx 0
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_hen"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_hen"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"zhe_guang"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"zhe_guang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jie_ying"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jie_ying"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"zhao_xi"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"zhao_xi"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"shi_ying"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"shi_ying"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_xi"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_xi"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"fan_zhao"}] run scoreboard players set #t wp_idx 7
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"fan_zhao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"shuang_ying"}] run scoreboard players set #t wp_idx 8
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"shuang_ying"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"ying_sheng"}] run scoreboard players set #t wp_idx 9
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"ying_sheng"}] run scoreboard players set #t wp_found 1
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_jing"}] run scoreboard players set #t wp_idx 10
execute if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[{id:"jing_jing"}] run scoreboard players set #t wp_found 1
