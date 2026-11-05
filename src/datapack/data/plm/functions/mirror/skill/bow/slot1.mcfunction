# 第 1 槽：普通绽放（60% + 镜花·保）；不足时补原目标 50%
scoreboard players operation #bow_slot_pct mirror_calc = #bow_splash mirror_calc
scoreboard players set #bow_fb mirror_calc 50
function plm:mirror/skill/bow/slot_apply
