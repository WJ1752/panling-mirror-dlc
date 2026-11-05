# append SKL 第 3 条（按 form 分支）
execute if score #t wp_form matches 1 run data modify storage plm:weapon entry set value {id:"fen_ying_ji",val:0}
execute if score #t wp_form matches 1 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 1 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 2 run data modify storage plm:weapon entry set value {id:"ying_chi",val:0}
execute if score #t wp_form matches 2 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 2 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 3 run data modify storage plm:weapon entry set value {id:"shui_yue_kuan",val:0}
execute if score #t wp_form matches 3 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 3 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 4 run data modify storage plm:weapon entry set value {id:"ying_sui_duo",val:0}
execute if score #t wp_form matches 4 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 4 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 5 run data modify storage plm:weapon entry set value {id:"jing_xia_jiu",val:0}
execute if score #t wp_form matches 5 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 5 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 5 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 6 run data modify storage plm:weapon entry set value {id:"ta_pian_qiang",val:0}
execute if score #t wp_form matches 6 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 6 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 6 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
