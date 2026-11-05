# 统计槽 5 当前有效五纹数（DMG 0..3 + SKL 0..3 + FX 0..1）→ wp_n_dmg / wp_n_skl / wp_n_fx / wp_count
# 只读槽 5；磨镜台输出位的 Lore 重写用（槽 3 版本见 affix/count.mcfunction）。
scoreboard players set #t wp_n_dmg 0
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_dmg[0] run scoreboard players add #t wp_n_dmg 1
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_dmg[1] run scoreboard players add #t wp_n_dmg 1
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_dmg[2] run scoreboard players add #t wp_n_dmg 1
scoreboard players set #t wp_n_skl 0
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_skl[0] run scoreboard players add #t wp_n_skl 1
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_skl[1] run scoreboard players add #t wp_n_skl 1
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_skl[2] run scoreboard players add #t wp_n_skl 1
scoreboard players set #t wp_n_fx 0
execute if data block ~ ~ ~ Items[{Slot:5b}].tag.mirror_fx[0] run scoreboard players add #t wp_n_fx 1
scoreboard players set #t wp_count 0
scoreboard players operation #t wp_count += #t wp_n_dmg
scoreboard players operation #t wp_count += #t wp_n_skl
scoreboard players operation #t wp_count += #t wp_n_fx
