# 第 3 槽：高强度槽序号 = 3（或旧箭的 1）时用 100% + 映水·强（补原目标也用该强度）；
# 若第 3 槽来自镜花·弹（高强度槽是 4 或没有），仍按普通 60%，补原目标 50%。
execute if score #bow_flower mirror_calc matches 1 run scoreboard players operation #bow_slot_pct mirror_calc = #bow_pct mirror_calc
execute if score #bow_flower mirror_calc matches 3 run scoreboard players operation #bow_slot_pct mirror_calc = #bow_pct mirror_calc
execute unless score #bow_flower mirror_calc matches 1 unless score #bow_flower mirror_calc matches 3 run scoreboard players operation #bow_slot_pct mirror_calc = #bow_splash mirror_calc
execute if score #bow_flower mirror_calc matches 1 run scoreboard players operation #bow_fb mirror_calc = #bow_pct mirror_calc
execute if score #bow_flower mirror_calc matches 3 run scoreboard players operation #bow_fb mirror_calc = #bow_pct mirror_calc
execute unless score #bow_flower mirror_calc matches 1 unless score #bow_flower mirror_calc matches 3 run scoreboard players set #bow_fb mirror_calc 50
function plm:mirror/skill/bow/slot_apply
