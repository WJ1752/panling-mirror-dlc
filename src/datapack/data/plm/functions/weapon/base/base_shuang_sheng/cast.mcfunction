# 双生倒影入队：20% 强度的相克倒影阵，同点、0.5s 后（due=2 个 5t）。
# 相克表与 plm:mirror/skill/furnace/twin/element/counter 一致（1金→2木、2木→5土、3水→4火、4火→1金、5土→3水）。
# 直接算进 #tw_el，不改写 @s mirror_zf_el，避免污染主阵/镜匣的元素快照。
scoreboard players operation #tw_base mirror_skill_tmp = @s mirror_zf_raw_dmg
scoreboard players set #tw_ratio mirror_skill_ratio 200
scoreboard players set #tw_el mirror_skill_tmp3 0
execute if score @s mirror_zf_main_el matches 1 run scoreboard players set #tw_el mirror_skill_tmp3 2
execute if score @s mirror_zf_main_el matches 2 run scoreboard players set #tw_el mirror_skill_tmp3 5
execute if score @s mirror_zf_main_el matches 3 run scoreboard players set #tw_el mirror_skill_tmp3 4
execute if score @s mirror_zf_main_el matches 4 run scoreboard players set #tw_el mirror_skill_tmp3 1
execute if score @s mirror_zf_main_el matches 5 run scoreboard players set #tw_el mirror_skill_tmp3 3
execute unless score #tw_el mirror_skill_tmp3 matches 1..5 run return 0
scoreboard players set #tw_due mirror_zf_tmp 2
function plm:mirror/skill/furnace/twin/echo/spawn
