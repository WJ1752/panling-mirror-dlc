# 从 12 条 DMG 中不重复抽一条 → #t wp_idx 1..12
# 最多重抽 20 次；仍重复则按 1..12 顺序找第一个未用 id 兜底
scoreboard players set #t wp_attempt 0
function plm:weapon/affix/pick_dmg/try
