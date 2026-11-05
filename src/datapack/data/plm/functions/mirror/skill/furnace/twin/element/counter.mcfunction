# 相克元素：输入/输出 @s mirror_zf_el（1 金 / 2 木 / 3 水 / 4 火 / 5 土）
# 表（设计 §2.5.1）：金→木、木→土、土→水、水→火、火→金。
# 未识别（0）保持 0，调用方据此判定「副手需要元素」。
scoreboard players set #tw_ctr mirror_zf_tmp 0
execute if score @s mirror_zf_el matches 1 run scoreboard players set #tw_ctr mirror_zf_tmp 2
execute if score @s mirror_zf_el matches 2 run scoreboard players set #tw_ctr mirror_zf_tmp 5
execute if score @s mirror_zf_el matches 3 run scoreboard players set #tw_ctr mirror_zf_tmp 4
execute if score @s mirror_zf_el matches 4 run scoreboard players set #tw_ctr mirror_zf_tmp 1
execute if score @s mirror_zf_el matches 5 run scoreboard players set #tw_ctr mirror_zf_tmp 3
scoreboard players operation @s mirror_zf_el = #tw_ctr mirror_zf_tmp
