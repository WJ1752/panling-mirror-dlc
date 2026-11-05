# 第 4 槽：2 件套花影上限 5 时，花影满的高强度槽是第 4 槽（100% + 映水·强）；
# 否则（镜花·弹的额外槽）固定普通绽放（60% + 镜花·保）；补原目标分别用对应强度。
execute if score #bow_flower mirror_calc matches 4 run scoreboard players operation #bow_slot_pct mirror_calc = #bow_pct mirror_calc
execute unless score #bow_flower mirror_calc matches 4 run scoreboard players operation #bow_slot_pct mirror_calc = #bow_splash mirror_calc
execute if score #bow_flower mirror_calc matches 4 run scoreboard players operation #bow_fb mirror_calc = #bow_pct mirror_calc
execute unless score #bow_flower mirror_calc matches 4 run scoreboard players set #bow_fb mirror_calc 50
function plm:mirror/skill/bow/slot_apply
