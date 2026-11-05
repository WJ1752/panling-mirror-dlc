# append SKL 第 1 条（按 form 分支）
execute if score #t wp_form matches 1 run data modify storage plm:weapon entry set value {id:"ying_xin",val:0}
execute if score #t wp_form matches 1 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 1 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 2 run data modify storage plm:weapon entry set value {id:"lie_shen",val:0}
execute if score #t wp_form matches 2 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 2 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 3 run data modify storage plm:weapon entry set value {id:"jing_hua_tan",val:0}
execute if score #t wp_form matches 3 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 3 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 4 run data modify storage plm:weapon entry set value {id:"liu_ying_jiu",val:0}
execute if score #t wp_form matches 4 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 4 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 5 run data modify storage plm:weapon entry set value {id:"dao_ying_qiang",val:0}
execute if score #t wp_form matches 5 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 5 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 5 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
execute if score #t wp_form matches 6 run data modify storage plm:weapon entry set value {id:"ta_yin_cheng",val:0}
execute if score #t wp_form matches 6 run execute store result storage plm:weapon val int 1 run scoreboard players get #t wp_val
execute if score #t wp_form matches 6 run data modify storage plm:weapon entry.val set from storage plm:weapon val
execute if score #t wp_form matches 6 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl append from storage plm:weapon entry
