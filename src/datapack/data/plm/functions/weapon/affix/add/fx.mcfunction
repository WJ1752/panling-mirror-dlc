# 追加一条 FX（上限 1）
scoreboard players set #t wp_n_fx 0
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[0] run scoreboard players add #t wp_n_fx 1
execute if score #t wp_n_fx matches 1.. run return 0
function plm:weapon/affix/pick_fx
# 池里没有可用词条时 pick 会留下 wp_idx 0；此时不 roll/append，也不算“已加纹”。
execute if score #t wp_idx matches ..0 run return 0
function plm:weapon/affix/roll_val
function plm:weapon/affix/append/fx
scoreboard players set #t wp_added 1
