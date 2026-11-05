# SKL 兜底：按器形 6 条池顺序找第一个未用；6 条全用则 wp_idx=0（append 不执行）
scoreboard players set #t wp_found 0
scoreboard players set #t wp_idx 0
# form 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_xin"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_xin"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"chi_jing"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"chi_jing"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"fen_ying_ji"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"fen_ying_ji"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"fen_ying_shi"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"fen_ying_shi"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ming_jing_zao"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ming_jing_zao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_xin_su"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 1 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_xin_su"}] run scoreboard players set #t wp_found 1
# form 2
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"lie_shen"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"lie_shen"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_zhong"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_zhong"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_chi"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_chi"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"lie_xu"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"lie_xu"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"chong_ying_xu"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"chong_ying_xu"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_sui_zhi"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 2 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_sui_zhi"}] run scoreboard players set #t wp_found 1
# form 3
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_hua_tan"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_hua_tan"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_hua_bao"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_hua_bao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"shui_yue_kuan"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"shui_yue_kuan"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"shui_yue_jiu"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"shui_yue_jiu"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"hua_ying_su"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"hua_ying_su"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_shui_qiang"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 3 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_shui_qiang"}] run scoreboard players set #t wp_found 1
# form 4
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"liu_ying_jiu"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"liu_ying_jiu"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"liu_ying_su"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"liu_ying_su"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_sui_duo"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_sui_duo"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_sui_qiang"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ying_sui_qiang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"lian_ying_yi"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"lian_ying_yi"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"chong_ying_chuan"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 4 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"chong_ying_chuan"}] run scoreboard players set #t wp_found 1
# form 5
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"dao_ying_qiang"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"dao_ying_qiang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"dao_ying_kuai"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"dao_ying_kuai"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_xia_jiu"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"jing_xia_jiu"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"gong_ming_shang"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"gong_ming_shang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"gong_ming_xiao"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"gong_ming_xiao"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"shuang_sheng_qi"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 5 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"shuang_sheng_qi"}] run scoreboard players set #t wp_found 1
# form 6
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ta_yin_cheng"}] run scoreboard players set #t wp_idx 1
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ta_yin_cheng"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ta_pian_shang"}] run scoreboard players set #t wp_idx 2
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ta_pian_shang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ta_pian_qiang"}] run scoreboard players set #t wp_idx 3
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"ta_pian_qiang"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"xian_ying_jiu"}] run scoreboard players set #t wp_idx 4
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"xian_ying_jiu"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"zhao_yao_shen"}] run scoreboard players set #t wp_idx 5
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"zhao_yao_shen"}] run scoreboard players set #t wp_found 1
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"he_yin_sheng"}] run scoreboard players set #t wp_idx 6
execute if score #t wp_form matches 6 if score #t wp_found matches 0 unless data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[{id:"he_yin_sheng"}] run scoreboard players set #t wp_found 1
