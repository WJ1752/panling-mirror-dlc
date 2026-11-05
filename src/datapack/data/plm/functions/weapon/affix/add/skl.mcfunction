# 追加一条 SKL（上限 3）：从本器形 6 条池中不重复抽；val 取 #t wp_val
# 说明：Phase 1 不抽取技能纹的占位实现已替换为真实抽取；旧「return 0」只保留 form=0 的兜底。
execute unless score #t wp_form matches 1..6 run return 0
scoreboard players set #t wp_n_skl 0
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[0] run scoreboard players add #t wp_n_skl 1
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[1] run scoreboard players add #t wp_n_skl 1
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[2] run scoreboard players add #t wp_n_skl 1
execute if score #t wp_n_skl matches 3.. run return 0
function plm:weapon/affix/pick_skl
# 池里 6 条都已被占用时 pick 会留下 wp_idx 0；此时不 roll/append，也不算“已加纹”。
execute if score #t wp_idx matches ..0 run return 0
function plm:weapon/affix/roll_val
function plm:weapon/affix/append/skl
scoreboard players set #t wp_added 1
